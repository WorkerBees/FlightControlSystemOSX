//
//  FCSAnnotation.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/29/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSAnnotation.h"

@implementation FCSAnnotation

@synthesize coordinate=_coordinate;

- (NSString *)title
{
    switch(self.mission_item.command)
    {
        case FCSMAVCMDType_NAV_LAND: return @"Land";
        case FCSMAVCMDType_NAV_WAYPOINT: return @"Waypoint";
        case FCSMAVCMDType_NAV_TAKEOFF: return @"Takeoff";
        default: return @"Waypoint";
    }
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"Altitude: %0.1fm", self.mission_item.z];
}

- (instancetype)initWithMissionItem:(FCSMAVLinkMissionItemMessage *)mission_item
{
    self = [self init];

    self.mission_item = mission_item;
    _coordinate = CLLocationCoordinate2DMake(mission_item.x, mission_item.y);

    return self;
}

@end
