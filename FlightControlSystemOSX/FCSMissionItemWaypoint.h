//
//  FCSMissionItemWaypoint.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItem.h"
@import MapKit;

/**
 *  A waypoint mission item.  Waypoints are a sphere in 3-space that provides a navigation target.  The sphere is about the specified point with a radius of acceptanceRadius.  aimRadius can be used to pass by the waypoint some meters away, in a clockwise or counter-clockwise direction, to allow for trajectory control.
 */
@interface FCSMissionItemWaypoint : FCSMissionItem

/**
 *  Acceptance radius in meters (if the sphere with this radius is hit, the MISSION counts as reached)
 */
@property CLLocationDistance    acceptanceRadius;
/**
 *  0 to pass through the WP, if > 0 radius in meters to pass by WP. Positive value for clockwise orbit, negative value for counter-clockwise orbit. Allows trajectory control.
 */
@property CLLocationDistance    aimRadius;

/**
 *  The position of the waypoint
 */
@property CLLocationCoordinate2D position;
/**
 *  Altitude above sea level of the waypoint.
 */
@property CLLocationDistance     altitude;

@end
