//
//  FCSMAVLinkHeartbeatMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkHeartbeatMessage.h"

@interface FCSMAVLinkHeartbeatMessage ()

@property mavlink_heartbeat_t *heartbeat;

@end

@implementation FCSMAVLinkHeartbeatMessage

- (void)dealloc
{
    free(_heartbeat);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _heartbeat = malloc(sizeof(*_heartbeat));
        bzero(_heartbeat, sizeof(*_heartbeat));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _heartbeat = malloc(sizeof(*_heartbeat));
        mavlink_msg_heartbeat_decode(message, _heartbeat);
    }

    return self;
}

- (NSString *)description
{
    NSString *mavType;
    switch(self.mavType)
    {
        case FCSMAVType_GENERIC: mavType = @"Generic"; break;
        case FCSMAVType_FIXED_WING: mavType = @"Fixed Wing"; break;
        case FCSMAVType_QUADROTOR: mavType = @"Quadrotor"; break;
        case FCSMAVType_COAXIAL: mavType = @"Coaxial"; break;
        case FCSMAVType_HELICOPTER: mavType = @"Helicopter"; break;
        case FCSMAVType_ANTENNA_TRACKER: mavType = @"Antenna Tracker"; break;
        case FCSMAVType_GCS: mavType = @"Ground Control"; break;
        case FCSMAVType_AIRSHIP: mavType = @"Airship"; break;
        case FCSMAVType_FREE_BALLOON: mavType = @"Balloon"; break;
        case FCSMAVType_ROCKET: mavType = @"Rocket"; break;
        case FCSMAVType_GROUND_ROVER: mavType = @"Ground Rover"; break;
        case FCSMAVType_SURFACE_BOAT: mavType = @"Surface Boat"; break;
        case FCSMAVType_SUBMARINE: mavType = @"Submarine"; break;
        case FCSMAVType_HEXAROTOR: mavType = @"Hexarotor"; break;
        case FCSMAVType_OCTOROTOR: mavType = @"Ocotorotor"; break;
        case FCSMAVType_TRICOPTER: mavType = @"Tricopter"; break;
        case FCSMAVType_FLAPPING_WING: mavType = @"Flapping Wing"; break;
        case FCSMAVType_KITE: mavType = @"Kite"; break;
        default: mavType = [NSString stringWithFormat:@"Unknown(0x%02x)", _heartbeat->type];
    }

    NSString *autoPilot;
    switch(self.autoPilot)
    {
        case MAV_AUTOPILOT_GENERIC: autoPilot = @"Generic"; break;
        case MAV_AUTOPILOT_PIXHAWK: autoPilot = @"Pixhawk"; break;
        case MAV_AUTOPILOT_SLUGS: autoPilot = @"Slugs"; break;
        case MAV_AUTOPILOT_ARDUPILOTMEGA: autoPilot = @"Ardupilotmega"; break;
        case MAV_AUTOPILOT_OPENPILOT: autoPilot = @"Openpilot"; break;
        case MAV_AUTOPILOT_GENERIC_WAYPOINTS_ONLY: autoPilot = @"Generic waypoints only"; break;
        case MAV_AUTOPILOT_GENERIC_WAYPOINTS_AND_SIMPLE_NAVIGATION_ONLY: autoPilot = @"Generic waypoints and simple navigation only"; break;
        case MAV_AUTOPILOT_GENERIC_MISSION_FULL: autoPilot = @"Generic mission full"; break;
        case MAV_AUTOPILOT_INVALID: autoPilot = @"Invalid"; break;
        case MAV_AUTOPILOT_PPZ: autoPilot = @"Ppz"; break;
        case MAV_AUTOPILOT_UDB: autoPilot = @"Udb"; break;
        case MAV_AUTOPILOT_FP: autoPilot = @"Fp"; break;
        case MAV_AUTOPILOT_PX4: autoPilot = @"Px4"; break;
        default: autoPilot = [NSString stringWithFormat:@"Unknown(0x%02x)", _heartbeat->autopilot];
    }

    NSMutableArray *modeSet = [NSMutableArray arrayWithCapacity:5];
    if(self.baseMode & MAV_MODE_FLAG_CUSTOM_MODE_ENABLED)
    {
        switch(self.customFlightMode)
        {
            case FCSCustomFlightMode_MANUAL: [modeSet addObject:@"Manual"]; break;
            case FCSCustomFlightMode_CIRCLE: [modeSet addObject:@"Circle"]; break;
            case FCSCustomFlightMode_STABILIZE: [modeSet addObject:@"Stabilize"]; break;
            case FCSCustomFlightMode_TRAINING: [modeSet addObject:@"Training"]; break;
            case FCSCustomFlightMode_ACRO: [modeSet addObject:@"Acro"]; break;
            case FCSCustomFlightMode_FLY_BY_WIRE_A: [modeSet addObject:@"Fly By Wire A"]; break;
            case FCSCustomFlightMode_FLY_BY_WIRE_B: [modeSet addObject:@"Fly By Wire B"]; break;
            case FCSCustomFlightMode_CRUISE: [modeSet addObject:@"Cruise"]; break;
            case FCSCustomFlightMode_AUTOTUNE: [modeSet addObject:@"Autotune"]; break;
            case FCSCustomFlightMode_RESERVED_9: [modeSet addObject:@"Reserved 9"]; break;
            case FCSCustomFlightMode_AUTO: [modeSet addObject:@"Auto"]; break;
            case FCSCustomFlightMode_RTL: [modeSet addObject:@"RTL"]; break;
            case FCSCustomFlightMode_LOITER: [modeSet addObject:@"Loiter"]; break;
            case FCSCustomFlightMode_RESERVED_13: [modeSet addObject:@"Reserved 13"]; break;
            case FCSCustomFlightMode_RESERVED_14: [modeSet addObject:@"Reserved 14"]; break;
            case FCSCustomFlightMode_GUIDED: [modeSet addObject:@"Guided"]; break;
            case FCSCustomFlightMode_INITIALIZING: [modeSet addObject:@"Initializing"]; break;
            default: [modeSet addObject:[NSString stringWithFormat:@"Mode 0x%08x",self.customFlightMode]];
        }
    }
    if(self.baseMode & MAV_MODE_FLAG_TEST_ENABLED) { [modeSet addObject:@"Test"]; }
    if(self.baseMode & MAV_MODE_FLAG_AUTO_ENABLED) { [modeSet addObject:@"Auto"]; }
    if(self.baseMode & MAV_MODE_FLAG_GUIDED_ENABLED) { [modeSet addObject:@"Guided"]; }
    if(self.baseMode & MAV_MODE_FLAG_STABILIZE_ENABLED) { [modeSet addObject:@"Stabilize"]; }
    if(self.baseMode & MAV_MODE_FLAG_HIL_ENABLED) { [modeSet addObject:@"HIL"]; }
    if(self.baseMode & MAV_MODE_FLAG_MANUAL_INPUT_ENABLED) { [modeSet addObject:@"Manual Input"]; }
    if(self.baseMode & MAV_MODE_FLAG_SAFETY_ARMED) { [modeSet addObject:@"Safety Armed"]; }
    NSString *baseMode = [modeSet componentsJoinedByString:@"|"];

    NSString *mavState;
    switch (self.systemStatus)
    {
        case MAV_STATE_UNINIT: mavState = @"Uninitialized"; break;
        case MAV_STATE_BOOT: mavState = @"Booting"; break;
        case MAV_STATE_CALIBRATING: mavState = @"Calibrating"; break;
        case MAV_STATE_STANDBY: mavState = @"Standby"; break;
        case MAV_STATE_ACTIVE: mavState = @"Active"; break;
        case MAV_STATE_CRITICAL: mavState = @"Critical"; break;
        case MAV_STATE_EMERGENCY: mavState = @"Emergency"; break;
        case MAV_STATE_POWEROFF: mavState = @"Poweroff"; break;
        default: mavState = [NSString stringWithFormat:@"Unknown(0x%02x)", self.systemStatus];
    }

    return  [NSString stringWithFormat:@"HEARTBEAT: %@ - %@ (%@) - %@ - version %u",
              mavType,
              autoPilot,
              baseMode,
              mavState,
              _heartbeat->mavlink_version
              ];
}

#pragma mark - Accessors to convert internal MAVLink enums into type-checked Objective-C ones.

- (FCSMAVType)mavType
{
    return _heartbeat->type;
}

- (void)setMavType:(FCSMAVType)mavType
{
    _heartbeat->type = mavType;
    mavlink_msg_heartbeat_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _heartbeat);
}

- (FCSAutopilotType)autoPilot
{
    return _heartbeat->autopilot;
}

- (void)setAutoPilot:(FCSAutopilotType)autoPilot
{
    _heartbeat->autopilot = autoPilot;
    mavlink_msg_heartbeat_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _heartbeat);
}

- (FCSBaseModeFlags)baseMode
{
    return _heartbeat->base_mode;
}

- (void)setBaseMode:(FCSBaseModeFlags)baseMode
{
    _heartbeat->base_mode = baseMode;
    mavlink_msg_heartbeat_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _heartbeat);
}

- (FCSMAVStateType)systemStatus
{
    return _heartbeat->system_status;
}

- (void)setSystemStatus:(FCSMAVStateType)systemStatus
{
    _heartbeat->system_status = systemStatus;
    mavlink_msg_heartbeat_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _heartbeat);
}

- (FCSCustomFlightMode)customFlightMode
{
    return _heartbeat->custom_mode;
}

- (void)setCustomFlightMode:(FCSCustomFlightMode)customFlightMode
{
    _heartbeat->custom_mode = customFlightMode;
    mavlink_msg_heartbeat_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _heartbeat);
}

@end
