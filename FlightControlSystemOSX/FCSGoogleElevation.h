//
//  FCSGoogleElevation.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/8/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface FCSGoogleElevation : NSObject

+ (NSString *)encodeLocation:(CLLocationCoordinate2D)location;

+ (void) altitudeAtLocation:(CLLocationCoordinate2D)location callback:(void (^)(CLLocationDistance altitude))handler;
+ (void) altitudeAtLocations:(NSArray *)locations callback:(void (^)(NSArray * altitudes))handler;

@end
