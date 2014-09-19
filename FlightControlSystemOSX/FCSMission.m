//
//  FCSMissionItem.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/11/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMission.h"

#import "FCSMissionItem_Private.h"

#import "FCSMissionItemWaypoint.h"
#import "FCSMissionItemTakeoff.h"
#import "FCSMissionItemLand.h"

@interface FCSMission ()

@property NSMutableArray *theItems;

@end

@implementation FCSMission

- (instancetype)init
{
    self = [super init];

    _theItems = [NSMutableArray arrayWithCapacity:5];

    return self;
}

- (NSArray *)items
{
    return self.theItems;
}

- (FCSMissionItem *)makeMissionItemFromMessage:(FCSMAVLinkMissionItemMessage *)message
{
    FCSMissionItem *result;
    switch(message.command)
    {
        case FCSMAVCMDType_NAV_TAKEOFF:
        {
            result = [FCSMissionItemTakeoff alloc];
        } break;

        case FCSMAVCMDType_NAV_WAYPOINT:
        {
            result = [FCSMissionItemWaypoint alloc];
        } break;

        case FCSMAVCMDType_NAV_LAND:
        {
            result = [FCSMissionItemLand alloc];
        } break;

        default: result = [FCSMissionItem alloc];
    }

    result = [result initWithMessage:message];
    result.theMission = self;

    [self.theItems insertObject:result atIndex:(NSUInteger)message.sequenceNumber];

    return result;
}

- (void)removeMissionItemAtIndex:(NSUInteger)index
{
    [self.theItems removeObjectAtIndex:index];
}

- (void)moveMissionItemFromIndex:(NSUInteger)source toIndex:(NSUInteger)dest
{
    id item = [self.theItems objectAtIndex:source];
    [self.theItems removeObjectAtIndex:source];
    [self.theItems insertObject:item atIndex:dest];
}

- (NSString *)description
{
    return [self.items description];
}

@end
