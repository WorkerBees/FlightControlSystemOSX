//
//  FCSMissionItemLand.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItem.h"
@import MapKit;

@interface FCSMissionItemLand : FCSMissionItem

/**
 *  The position of the waypoint
 */
@property CLLocationCoordinate2D position;
/**
 *  Altitude above sea level of the waypoint.
 */
@property CLLocationDistance     altitude;

@end
