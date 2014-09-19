//
//  FCSMissionItem.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItem_Private.h"

static const NSString *PARAM1 = @"param1";
static const NSString *PARAM2 = @"param2";
static const NSString *PARAM3 = @"param3";
static const NSString *PARAM4 = @"param4";
static const NSString *PARAM5 = @"param5";
static const NSString *PARAM6 = @"param6";
static const NSString *PARAM7 = @"param7";

@implementation FCSMissionItem

- (NSUInteger)sequenceNumber
{
    if(self.theMission == nil) return NSNotFound;
    return [self.theMission.items indexOfObject:self];
}

- (NSDictionary *)parameters
{
    return self.theParameters;
}

- (NSArray *)paramMap
{
    return @[
             PARAM1,
             PARAM2,
             PARAM3,
             PARAM4,
             PARAM5,
             PARAM6,
             PARAM7,
             ];
}

- (float)param:(FCSParamNumber)param
{
    id paramName = [self.paramMap objectAtIndex:param];
    if(paramName == [NSNull null] || [self.theParameters objectForKey:paramName] == nil)
    {
        return 0.0;
    }
    else
    {
        return [[self.theParameters objectForKey:paramName] floatValue];
    }
}

- (void)setParam:(FCSParamNumber)param toValue:(float)value
{
    id paramName = [self.paramMap objectAtIndex:param];
    if(paramName == [NSNull null])
    {
        paramName = [NSString stringWithFormat:@"param%lu", param+1];
    }

    [self.theParameters setObject:[NSNumber numberWithFloat:value] forKey:paramName];
}

- (FCSMAVLinkMissionItemMessage *)message
{
    FCSMAVLinkMissionItemMessage *result = [[FCSMAVLinkMissionItemMessage alloc] init];

    result.sequenceNumber = (uint16_t)self.sequenceNumber;
    result.frame = FCSMavFrame_GLOBAL;
    result.command = FCSMAVCMDType_NAV_WAYPOINT;
    result.autoContinue = YES;

    result.param1 = [self param:Param1];
    result.param2 = [self param:Param2];
    result.param3 = [self param:Param3];
    result.param4 = [self param:Param4];
    result.x      = [self param:Param5];
    result.y      = [self param:Param6];
    result.z      = [self param:Param7];

    return result;
}

- (instancetype)init
{
    self = [super init];

    self.theParameters = [NSMutableDictionary dictionaryWithCapacity:7];
    self.name = @"UNSPECIFIED";

    return self;
}

- (instancetype)initWithMessage:(FCSMAVLinkMissionItemMessage *)message
{
    self = [super init];

    self.theParameters = [NSMutableDictionary dictionaryWithCapacity:7];
    self.name = [NSString stringWithFormat:@"UNSPECIFIED (%u)", message.command];

    if([self.paramMap objectAtIndex:Param1] != [NSNull null]) [self setParam:Param1 toValue:message.param1];
    if([self.paramMap objectAtIndex:Param2] != [NSNull null]) [self setParam:Param2 toValue:message.param2];
    if([self.paramMap objectAtIndex:Param3] != [NSNull null]) [self setParam:Param3 toValue:message.param3];
    if([self.paramMap objectAtIndex:Param4] != [NSNull null]) [self setParam:Param4 toValue:message.param4];
    if([self.paramMap objectAtIndex:Param5] != [NSNull null]) [self setParam:Param5 toValue:message.x];
    if([self.paramMap objectAtIndex:Param6] != [NSNull null]) [self setParam:Param6 toValue:message.y];
    if([self.paramMap objectAtIndex:Param7] != [NSNull null]) [self setParam:Param7 toValue:message.z];

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.name, self.parameters];
}

@end
