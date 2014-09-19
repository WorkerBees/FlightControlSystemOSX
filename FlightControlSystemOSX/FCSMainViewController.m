//
//  ViewController.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/15/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMainViewController.h"

#import "AppDelegate.h"

#import "FCSAnnotation.h"

@import MapKit;

@interface FCSMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet MKMapView *mapView;
@property (weak,nonatomic) IBOutlet NSTextField *feedback;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@end

@implementation FCSMainViewController

- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)annotationView
didChangeDragState:(MKAnnotationViewDragState)newDragState
   fromOldState:(MKAnnotationViewDragState)oldDragState
{
    FCSAnnotation *annotation = (FCSAnnotation *)annotationView.annotation;

    if(newDragState == MKAnnotationViewDragStateStarting)
    {
        NSLog(@"Drag starting from %@", annotation);
        annotationView.dragState = MKAnnotationViewDragStateDragging;
    }
    else if(newDragState == MKAnnotationViewDragStateEnding || newDragState == MKAnnotationViewDragStateCanceling)
    {
        NSLog(@"Drag ending at %@", annotation);
        annotationView.dragState = MKAnnotationViewDragStateNone;
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    if ([annotation isKindOfClass:[FCSAnnotation class]])
    {
        FCSAnnotation *note = annotation;

        MKAnnotationView* aView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"FCSAnnotationView"];
        if(aView == nil)
        {
            aView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                 reuseIdentifier:@"FCSAnnotationView"];
        }
        else
        {
            aView.annotation = annotation;
        }

        [note associateView:aView];

        return aView;
    }

    // Otherwise dunno what to do
    return nil;
}

#pragma mark - Auto-allocation methods

- (CLLocationManager *)locationManager
{
    if(_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }

    return _locationManager;
}

- (CLGeocoder *)geocoder
{
    if(_geocoder == nil)
    {
        _geocoder = [[CLGeocoder alloc] init];
    }

    return _geocoder;
}

#pragma mark - View setup and teardown

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationManager.distanceFilter = 10; // meters; send events if we move by this much

    self.feedback.hidden = YES;
}

- (void)viewWillAppear
{
    [super viewWillAppear];

    // Get latest position fix
    [self.locationManager startUpdatingLocation];
}

- (void)serialPortsWereConnected:(NSNotification *)notification
{
    FCSConnectionLink *theLink = [[notification userInfo] objectForKey:@"link"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Wait a suitable time period for the serial port driver to stabilize, and then open the link
        theLink.connected = YES;
    });
}

- (void)viewDidAppear
{
    // Find a serial connection and connect it
    NSLog(@"Looking for a link to connect");
    AppDelegate *myApp = (AppDelegate *)[NSApplication sharedApplication].delegate;
    FCSConnectionLink *theLink = myApp.connectionLinkManager.availableLinks.anyObject;
    NSLog(@"The connection manager gave me: %@", theLink);
    if(theLink != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            theLink.connected = YES;
        });
    }
    else
    {
        // Listen for new port becoming available
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(serialPortsWereConnected:) name:FCSNewSerialPortNotification object:myApp.connectionLinkManager];
    }
}

- (void)viewWillDisappear
{
    [self.locationManager stopUpdatingLocation];
    _locationManager = nil;

    [super viewWillDisappear];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Search for location

- (void)geocodeAddressString:(NSString *)addressString completionHandler:(CLGeocodeCompletionHandler)completionHandler
{
    [self.geocoder cancelGeocode];

    CLLocation *center = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude
                                                    longitude:self.mapView.centerCoordinate.longitude];
    CLLocation *NEcorner = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude + self.mapView.region.span.latitudeDelta
                                                      longitude:self.mapView.centerCoordinate.longitude + self.mapView.region.span.longitudeDelta];

    [self.geocoder geocodeAddressString:addressString
                               inRegion:[[CLCircularRegion alloc] initWithCenter:self.mapView.centerCoordinate
                                                                          radius:[NEcorner distanceFromLocation:center]
                                                                      identifier:nil]
                      completionHandler:completionHandler];
}

- (IBAction)searchLocationEntered:(NSSearchField *)sender
{
    [self geocodeAddressString:sender.stringValue completionHandler:^(NSArray *placemarks, NSError *error) {
        if(error == nil)
        {
            CLPlacemark *placemark = placemarks.firstObject;
            // Update the map view
            [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(placemark.location.coordinate,
                                                                       MAX(placemark.location.horizontalAccuracy * 4, 1000),
                                                                       MAX(placemark.location.horizontalAccuracy * 4, 1000))
                           animated:YES];
        }
        else
        {
            NSLog(@"Error: %@",error);
        }
    }];
}

#pragma mark - Location update delegate methods

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    (void)manager;

    CLLocation* location = [locations lastObject];

    // Update the map view
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                               MAX(location.horizontalAccuracy * 4, 1000),
                                                               MAX(location.horizontalAccuracy * 4, 1000))
                   animated:YES];
}

#pragma mark - Autocomplete search using text field delegate

- (void) controlTextDidChange: (NSNotification *)note
{
    static BOOL isCompleting = NO;
    NSTextView * fieldEditor = [note.userInfo objectForKey:@"NSFieldEditor"];

    if(!isCompleting)
    {
        isCompleting = YES;
        [fieldEditor complete:nil];
        isCompleting = NO;
    }
}

- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index
{
    (void)control;
    (void)words;
    (void)charRange;
/*
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];

    [self geocodeAddressString:textView.string
                      completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(error == nil)
         {
             CLLocation *center = [[CLLocation alloc] initWithLatitude:self.mapView.centerCoordinate.latitude
                                                             longitude:self.mapView.centerCoordinate.longitude];

             NSArray *sortedArray = [placemarks sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                 CLPlacemark *pl1 = obj1;
                 CLPlacemark *pl2 = obj2;
                 return [pl1.location distanceFromLocation:center] > [pl2.location distanceFromLocation:center];
             }];

             for (CLPlacemark *placemark in sortedArray)
             {
                 [results addObject:[NSString stringWithFormat:@"%@ %@, %@, %@, %@ (%0.2f miles)",
                                     placemark.subThoroughfare,
                                     placemark.thoroughfare,
                                     placemark.locality,
                                     placemark.subAdministrativeArea,
                                     placemark.administrativeArea,
                                     [placemark.location distanceFromLocation:center] / 1609.34
                                     ]];
             }
             NSLog(@"Completion lookup returned %lu items: %@",results.count, results);
         }
         else
         {
             NSLog(@"Completion lookup error: %@",error);
         }
     }];

    *index = (results.count > 0) ? 0 : -1;
    return results;
 */
    return words;
}


@end
