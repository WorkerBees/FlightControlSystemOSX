//
//  FCSMissionItemLand.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItemLand.h"
#import "FCSMissionItem_Private.h"

@implementation FCSMissionItemLand

- (NSArray *)paramMap
{
    return @[
             [NSNull null],
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

    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:LATITUDE];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:LONGITUDE];
    [self.theParameters setObject:[NSNumber numberWithDouble:0]  forKey:ALTITUDE];

    self.name = @"Land";

    return self;
}

- (instancetype)initWithMessage:(FCSMAVLinkMissionItemMessage *)message
{
    self = [super initWithMessage:message];

    self.name = @"Land";

    return self;
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
