//
//  FCSGoogleElevation.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/8/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;
@import MapKit;

/**
 *
 * @abstract A group of helper functions for finding altitudes above sea level of locations
 * @discussion Uses the Google Elevation API at https://developers.google.com/maps/documentation/elevation/ for lookups.  Requires network access.
 *
 */

@interface FCSGoogleElevation : NSObject

/**
 *  @abstract Returns the PolyLine encoded form of the specified single location.
 *  @discussion Implements the algorithm described at https://developers.google.com/maps/documentation/utilities/polylinealgorithm
 *
 *  @param location The location to encode.
 *
 *  @return An NSString instance containing the PolyLine encoded location
 *
 *  @see encodeLocations
 */

+ (NSString *)encodeLocation:(CLLocationCoordinate2D)location;

/**
 *  Encode the locations specified into PolyLine format, per the algorithm at https://developers.google.com/maps/documentation/utilities/polylinealgorithm
 *
 *  @param locations NSArray of NSValues containing CLLocationCoordinate2Ds
 *
 *  @return An NSString containing the encoded sequence of locations
 *
 *  @code [FCSGoogleElevation encodeLocations:@[ [NSValue valueWithMKCoordinate:{37.3,-122.5}] ]];
 */
+ (NSString *)encodeLocations:(NSArray *)locations;

/**
 *  Asynchronously determine the altitude above sea level of the ground at the specified location.  Uses the Google Elevation API to lookup the elevation.
 *
 *  @param location The location on the earth's surface for which to find the ground elevation
 *  @param handler  A callback function to which will be returned the altitude once the lookup is completed.
 */
+ (void) altitudeAtLocation:(CLLocationCoordinate2D)location callback:(void (^)(CLLocationDistance altitude))handler;

/**
 *  Asynchronously determine the altitude above sea level of the ground at the specified locations.  Uses the Google Elevation API to lookup the elevation.
 *
 *  @param locations An NSArray of NSValues containing CLLocationCoordinate2Ds
 *  @param handler   A callback function which will receive an NSArray with the altitudes once the lookup is completed.
 *
 *  @code [FCSGoogleElevation altitudeAtLocations:@[ [NSValue valueWithMKCoordinate:{37.3,-122.5}] ] callback:someblock];
 */
+ (void) altitudesAtLocations:(NSArray *)locations callback:(void (^)(NSArray * altitudes))handler;

@end
