//
//  ViewController.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/15/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMainViewController.h"

@import MapKit;

@interface FCSMainViewController () <MKMapViewDelegate, CLLocationManagerDelegate, NSTextFieldDelegate>

@property (weak) IBOutlet MKMapView *mapView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak,nonatomic) IBOutlet NSTextField *currentLocationDetail;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@end

static const NSInteger currentLocationMenuItemTag = 1;

@implementation FCSMainViewController

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
}

- (void)viewWillDisappear
{
    [self.locationManager stopUpdatingLocation];
    _locationManager = nil;
}

- (void)viewDidDisappear
{
    [super viewDidDisappear];
}

#pragma mark - Location detail visible

- (void)setCurrentLocationDetail:(NSString *)newDetail
                 enableAddButton:(BOOL)enableAddButton
{
    (void)enableAddButton;
    self.currentLocationDetail.stringValue = newDetail;
    self.currentLocationDetail.hidden = NO;

    [self.currentLocationDetail sizeToFit];
}

#pragma mark - Search for location

- (IBAction)searchLocationEntered:(NSSearchField *)sender
{
    [self.geocoder cancelGeocode];
    [self.geocoder geocodeAddressString:sender.stringValue
                               inRegion:nil
                      completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if(error == nil)
         {
             if(placemarks != nil) // nil if cancelled or error
             {
                 if ([placemarks count] > 0)
                 {
                     MKPlacemark *placemark = [placemarks objectAtIndex:0];
                     [self setCurrentLocationDetail:[NSString stringWithFormat:@"%@ %@\n%@, %@, %@",
                                                     placemark.subThoroughfare,
                                                     placemark.thoroughfare,
                                                     placemark.locality,
                                                     placemark.subAdministrativeArea,
                                                     placemark.administrativeArea]
                                    enableAddButton:NO];
                 }
             }
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
             if(placemarks != nil) // nil if cancelled or error
             {
                 if ([placemarks count] > 0)
                 {
                     MKPlacemark *placemark = [placemarks objectAtIndex:0];
                     [self setCurrentLocationDetail:[NSString stringWithFormat:@"%@ %@\n%@, %@, %@",
                                                     placemark.subThoroughfare,
                                                     placemark.thoroughfare,
                                                     placemark.locality,
                                                     placemark.subAdministrativeArea,
                                                     placemark.administrativeArea]
                                    enableAddButton:NO];
                 }
             }
         }
         else
         {
             NSLog(@"Error: %@",error);
         }
     }];


}

#pragma mark - Autocomplete search using text field delegate


- (NSArray *)control:(NSControl *)control
            textView:(NSTextView *)textView
         completions:(NSArray *)words
 forPartialWordRange:(NSRange)charRange
 indexOfSelectedItem:(NSInteger *)index
{
    (void)control;
    (void)words;
    (void)charRange;

    NSMutableArray *results = [NSMutableArray arrayWithCapacity:10];

    NSString *stringSoFar = textView.string;

    *index = -1;
    return results;
}


@end
