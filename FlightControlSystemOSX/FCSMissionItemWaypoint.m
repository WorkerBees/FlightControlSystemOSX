//
//  FCSMissionItemWaypoint.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItemWaypoint.h"
#import "FCSMissionItem_Private.h"

static const NSString *ACCEPTANCE_RADIUS = @"Acceptance Radius (m)";
static const NSString *AIM_RADIUS = @"Aim Radius (m)";

@implementation FCSMissionItemWaypoint

- (NSArray *)paramMap
{
    return @[
             [NSNull null],
             ACCEPTANCE_RADIUS,
             AIM_RADIUS,
             [NSNull null],
             LATITUDE,
             LONGITUDE,
             ALTITUDE,
             ];
}

- (instancetype)init
{
    self = [super init];

    [self.theParameters setObject:[NSNumber numberWithDouble:25]  forKey:ACCEPTANCE_RADIUS];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:AIM_RADIUS];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:LATITUDE];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:LONGITUDE];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:ALTITUDE];

    self.name = @"Waypoint";

    return self;
}

- (instancetype)initWithMessage:(FCSMAVLinkMissionItemMessage *)message
{
    self = [super initWithMessage:message];

    self.name = @"Waypoint";

    return self;
}

- (CLLocationDistance)acceptanceRadius
{
    return [[self.theParameters objectForKey:ACCEPTANCE_RADIUS] doubleValue];
}

- (void)setAcceptanceRadius:(CLLocationDistance)acceptanceRadius
{
    [self.theParameters setObject:[NSNumber numberWithDouble:acceptanceRadius] forKey:ACCEPTANCE_RADIUS];
}

- (CLLocationDistance)aimRadius
{
    return [[self.theParameters objectForKey:AIM_RADIUS] doubleValue];
}

- (void)setAimRadius:(CLLocationDistance)aimRadius
{
    [self.theParameters setObject:[NSNumber numberWithDouble:aimRadius] forKey:AIM_RADIUS];
}

- (CLLocationCoordinate2D)position
{
    CLLocationCoordinate2D result =  {
        [[self.theParameters objectForKey:LATITUDE] doubleValue],
        [[self.theParameters objectForKey:LONGITUDE] doubleValue]
    };

    return result;
}

- (void)setPosition:(CLLocationCoordinate2D)position
{
    [self.theParameters setObject:[NSNumber numberWithDouble:position.latitude]  forKey:LATITUDE];
    [self.theParameters setObject:[NSNumber numberWithDouble:position.longitude]  forKey:LONGITUDE];
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
