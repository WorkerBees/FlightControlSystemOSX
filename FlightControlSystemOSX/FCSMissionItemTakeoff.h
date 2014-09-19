//
//  FCSMissionItemTakeoff.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItem.h"
@import MapKit;

@interface FCSMissionItemTakeoff : FCSMissionItem

/**
 *  Minimum pitch angle to hold while taking off
 */
@property float minimumPitchAngle;

@property CLLocationDistance altitude;

@end
