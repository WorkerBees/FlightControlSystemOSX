//
//  Header.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItem.h"
#import "FCSMission.h"


typedef NS_ENUM(NSUInteger, FCSParamNumber)
{
    Param1 = 0,
    Param2 = 1,
    Param3 = 2,
    Param4 = 3,
    Param5 = 4,
    Param6 = 5,
    Param7 = 6,
};

static const NSString *LATITUDE = @"Latitude";
static const NSString *LONGITUDE = @"Longitude";
static const NSString *ALTITUDE = @"Altitude ASL (m)";

@interface FCSMissionItem ()

/**
 *  The mission of which this item is a step
 */
@property FCSMission *theMission;

/**
 *  The actual underlying dictionary of parameters which subclasses can modify
 */
@property NSMutableDictionary *theParameters;

/**
 *  The mapping between param number and the key into theParameters
 *  Subclasses should specify this mapping when constructed.  If a parameter is used, specify its name in that array position.
 *  If a parameter is unused, specify [NSNull null] in that array position.
 */
@property (readonly) NSArray *paramMap;

/**
 *  Fetch the parameter via a generic parameter number; useful for unimplemented mission item types.  For implemented types will automagically map to the correct parameter name.
 *
 *  @param param The number of the parameter to read
 *
 *  @return The value of the parameter for this mission item
 */
- (float)param:(FCSParamNumber)param;

/**
 *  Set a parameter in a generic way.  Useful for unimplemented mission item types.  For implemented types will automagically map to the correct parameter name.
 *
 *  @param param The number of the parameter to set
 *  @param value The value for the parameter.
 */
- (void)setParam:(FCSParamNumber)param toValue:(float)value;

@end
