//
//  ViewController.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/15/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMainViewController.h"

#import "AppDelegate.h"

#import "FCSMessageHandlerMissionTranferor.h"
#import "FCSAnnotation.h"

@import MapKit;

@interface FCSMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate, NSTextFieldDelegate, FCSWaypointListReceivedHandler>

@property (weak) IBOutlet MKMapView *mapView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak,nonatomic) IBOutlet NSTextField *currentLocationDetail;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@property FCSMessageHandlerMissionTranferor *missionTransfer;

@end

@implementation FCSMainViewController

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

        [note drawInView:aView];

        return aView;
    }

    // Otherwise dunno what to do
    return nil;
}

- (void)receivedMissionItem:(FCSMAVLinkMissionItemMessage *)mission_item
{
    switch(mission_item.command)
    {
        case FCSMAVCMDType_NAV_TAKEOFF:
        case FCSMAVCMDType_NAV_WAYPOINT:
        case FCSMAVCMDType_NAV_LAND:
            if(mission_item.x == 0 && mission_item.y == 0 && mission_item.z == 0)
            {
                NSLog(@"Ignoring waypoint with all 0s");
                return;
            }
            break;
        default:
            NSLog(@"We do not handle this type of waypoint yet");
            return;
    }

    // Make an annotation on the map
    FCSAnnotation *spot = [[FCSAnnotation alloc] initWithMissionItem:mission_item];
    [self.mapView addAnnotation:spot];
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
}

- (void)setStatusForPlacemark:(MKPlacemark *)placemark
{
    [self setCurrentLocationDetail:[NSString stringWithFormat:@"%@ %@\n%@, %@, %@",
                                    placemark.subThoroughfare,
                                    placemark.thoroughfare,
                                    placemark.locality,
                                    placemark.subAdministrativeArea,
                                    placemark.administrativeArea]
                   enableAddButton:NO];
}

- (void)setStatusForFirstPlacemarkOfArray:(NSArray *)placemarks
{
    if(placemarks != nil) // nil if cancelled or error
    {
        if ([placemarks count] > 0)
        {
            [self setStatusForPlacemark:[placemarks objectAtIndex:0]];
        }
    }
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

    self.currentLocationDetail.hidden = YES;
}

- (void)viewWillAppear
{
    [super viewWillAppear];

    // Get latest position fix
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidAppear
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Find a serial connection and connect it
        NSLog(@"Looking for a link to connect");
        AppDelegate *myApp = (AppDelegate *)[NSApplication sharedApplication].delegate;
        FCSConnectionLink *theLink = myApp.connectionLinkManager.availableLinks.anyObject;
        NSLog(@"The connection manager gave me: %@", theLink);
        if(theLink != nil)
        {
            theLink.connected = YES;
        }
    });

    // Create a waypoint list transferor
    _missionTransfer = [[FCSMessageHandlerMissionTranferor alloc] initWithDelegate:self];
}

- (void)viewWillDisappear
{
    [self.locationManager stopUpdatingLocation];
    _locationManager = nil;

    [super viewWillDisappear];
}

#pragma mark - Location detail visible

- (void)setCurrentLocationDetail:(NSString *)newDetail
                 enableAddButton:(BOOL)enableAddButton
{
    (void)enableAddButton;

    // Update UI on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentLocationDetail.stringValue = newDetail;
        self.currentLocationDetail.hidden = NO;

        [self.currentLocationDetail sizeToFit];
    });
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
            [self setStatusForFirstPlacemarkOfArray:placemarks];
        }
        else
        {
            NSLog(@"Error: %@",error);
        }
    }];
}

#pragma mark - Add waypoint

- (IBAction)addButtonClicked:(id)sender
{
    (void)sender;
}

#pragma mark - Remove waypoint

- (IBAction)deleteButtonClicked:(id)sender
{
    (void)sender;
}

#pragma mark - MapView delegate methods

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

    NSString *desc = [NSString stringWithFormat:@"%f%c, %f%c (+/- %0.0fm)",
                      ABS(location.coordinate.latitude),
                      location.coordinate.latitude > 0 ? 'N' : 'S',
                      ABS(location.coordinate.longitude),
                      location.coordinate.longitude > 0 ? 'E' : 'W',
                      location.horizontalAccuracy];
    NSLog(@"Setting description to: \"%@\"",desc);
    [self setCurrentLocationDetail:desc
                   enableAddButton:YES];

    // Can't run 2 geocodings at once, so abort the previous one
    [self.geocoder cancelGeocode];

    // Look up this location and get info about it
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error)
     {
         if(error == nil)
         {
             [self setStatusForFirstPlacemarkOfArray:placemarks];
         }
         else
         {
             NSLog(@"Error: %@",error);
         }
     }];
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
