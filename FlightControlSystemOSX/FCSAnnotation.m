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

- (void)associateView:(MKAnnotationView *)view
{
    NSAssert(view.annotation == self, @"View's annotation is not me!");

    CGPoint handle_offset;
    switch(self.mission_item.command)
    {
        case FCSMAVCMDType_NAV_LAND:     handle_offset = CGPointMake(-21.25, -29); break;
        case FCSMAVCMDType_NAV_WAYPOINT: handle_offset = CGPointMake(0, -30); break;
        case FCSMAVCMDType_NAV_TAKEOFF:  handle_offset = CGPointMake(17.5, -25); break;
        default:
            @throw [NSException exceptionWithName:@"Bad mission item"
                                           reason:@"You should not have a mission item of that type here!"
                                         userInfo:@{@"mission_item":self.mission_item}];
    }
    view.image = [NSImage imageNamed:self.title];
    view.centerOffset = handle_offset;
    view.canShowCallout = YES;

    NSImageView *calloutImageView = [[NSImageView alloc] init];
    calloutImageView.image = [NSImage imageNamed:self.title];
    view.leftCalloutAccessoryView = calloutImageView;
}

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
