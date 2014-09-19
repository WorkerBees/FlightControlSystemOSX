//
//  FCSMissionItemTakeoff.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItemTakeoff.h"
#import "FCSMissionItem_Private.h"

static const NSString *MINIMUM_PITCH = @"Minimum pitch angle";

@implementation FCSMissionItemTakeoff

- (NSArray *)paramMap
{
    return @[
             MINIMUM_PITCH,
             [NSNull null],
             [NSNull null],
             [NSNull null],
             LATITUDE,
             LONGITUDE,
             ALTITUDE,
             ];
}

- (instancetype)init
{
    self = [super init];

    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:MINIMUM_PITCH];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:ALTITUDE];

    self.name = @"Takeoff";

    return self;
}

- (instancetype)initWithMessage:(FCSMAVLinkMissionItemMessage *)message
{
    self = [super initWithMessage:message];

    self.name = @"Takeoff";

    return self;
}

- (float)minimumPitchAngle
{
    return [[self.theParameters objectForKey:MINIMUM_PITCH] floatValue];
}

- (void)setMinimumPitchAngle:(float)minimumPitchAngle
{
    [self.theParameters setObject:[NSNumber numberWithFloat:minimumPitchAngle]  forKey:MINIMUM_PITCH];
}

- (CLLocationDistance)altitude
{
    return [[self.theParameters objectForKey:ALTITUDE] doubleValue];
}

- (void)setAltitude:(CLLocationDistance)altitude
{
    [self.theParameters setObject:[NSNumber numberWithDouble:altitude] forKey:ALTITUDE];
}

@end
