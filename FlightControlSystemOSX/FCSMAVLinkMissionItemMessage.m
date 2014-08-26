//
//  FCSMAVLinkMissionItemMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMissionItemMessage.h"

@interface FCSMAVLinkMissionItemMessage ()

@property mavlink_mission_item_t *item;

@end

@implementation FCSMAVLinkMissionItemMessage

- (void)dealloc
{
    free(_item);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _item = malloc(sizeof(*_item));
        bzero(_item, sizeof(*_item));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _item = malloc(sizeof(*_item));
        mavlink_msg_mission_item_decode(message, _item);
    }

    return self;
}

- (NSString *)description
{
    NSString *command;
    switch(self.command)
    {
        case FCSMAVCMDType_NAV_WAYPOINT: command = @"Waypoint"; break;
        case FCSMAVCMDType_NAV_LOITER_UNLIM: command = @"Loiter Unlimited"; break;
        case FCSMAVCMDType_NAV_LOITER_TURNS: command = @"Loiter Turns"; break;
        case FCSMAVCMDType_NAV_LOITER_TIME: command = @"Loiter Time"; break;
        case FCSMAVCMDType_NAV_RETURN_TO_LAUNCH: command = @"RTL"; break;
        case FCSMAVCMDType_NAV_LAND: command = @"Land"; break;
        case FCSMAVCMDType_NAV_TAKEOFF: command = @"Takeoff"; break;
        case FCSMAVCMDType_NAV_ROI: command = @"ROI"; break;
        case FCSMAVCMDType_NAV_PATHPLANNING: command = @"Path Planning"; break;
        case FCSMAVCMDType_NAV_LAST: command = @"Nav Last"; break;
        case FCSMAVCMDType_CONDITION_DELAY: command = @"Condition Delay"; break;
        case FCSMAVCMDType_CONDITION_CHANGE_ALT: command = @"Condition Change Altitude"; break;
        case FCSMAVCMDType_CONDITION_DISTANCE: command = @"Condition Distance"; break;
        case FCSMAVCMDType_CONDITION_YAW: command = @"Condition Yaw"; break;
        case FCSMAVCMDType_CONDITION_LAST: command = @"Condition Last"; break;
        case FCSMAVCMDType_DO_SET_MODE: command = @"Set Mode"; break;
        case FCSMAVCMDType_DO_JUMP: command = @"Jump"; break;
        case FCSMAVCMDType_DO_CHANGE_SPEED: command = @"Change Speed"; break;
        case FCSMAVCMDType_DO_SET_HOME: command = @"Set Home"; break;
        case FCSMAVCMDType_DO_SET_PARAMETER: command = @"Set Parameter"; break;
        case FCSMAVCMDType_DO_SET_RELAY: command = @"Set Relay"; break;
        case FCSMAVCMDType_DO_REPEAT_RELAY: command = @"Repeat Relay"; break;
        case FCSMAVCMDType_DO_SET_SERVO: command = @"Set Servo"; break;
        case FCSMAVCMDType_DO_REPEAT_SERVO: command = @"Repeat Servo"; break;
        case FCSMAVCMDType_DO_CONTROL_VIDEO: command = @"Control Video"; break;
        case FCSMAVCMDType_DO_LAST: command = @"Do Last"; break;
        case FCSMAVCMDType_PREFLIGHT_CALIBRATION: command = @"Calibrate"; break;
        case FCSMAVCMDType_PREFLIGHT_SET_SENSOR_OFFSETS: command = @"Set Sensor Offsets"; break;
        case FCSMAVCMDType_PREFLIGHT_STORAGE: command = @"Storage"; break;
        case FCSMAVCMDType_PREFLIGHT_REBOOT_SHUTDOWN: command = @"Reboot Shutdown"; break;
        case FCSMAVCMDType_OVERRIDE_GOTO: command = @"Override Goto"; break;
        case FCSMAVCMDType_MISSION_START: command = @"Mission Start"; break;
        case FCSMAVCMDType_COMPONENT_ARM_DISARM: command = @"Arm/Disarm"; break;
        default: command = [NSString stringWithFormat:@"Unknown(%u)", self.command];
    }

    NSString *frame;
    switch(self.frame)
    {
        case FCSMavFrame_GLOBAL: frame = @"Global"; break;
        case FCSMavFrame_GLOBAL_RELATIVE_ALT: frame = @"Relative"; break;
        case FCSMavFrame_LOCAL_ENU: frame = @"Local ENU"; break;
        case FCSMavFrame_LOCAL_NED: frame = @"Local NED"; break;
        case FCSMavFrame_MISSION: frame = @"Mission"; break;
        default: frame = [NSString stringWithFormat:@"Unknown(%u)", self.frame];
    }

    return [NSString stringWithFormat:@"MISSION_ITEM: %u on 0x%02x/0x%02x - %@(%@)",
            self.sequenceNumber,
            self.targetSystem,
            self.targetComponent,
            command,
            frame];
}

- (FCSMAVCMDType)command
{
    return _item->command;
}

- (void)setCommand:(FCSMAVCMDType)command
{
    _item->command = command;
    mavlink_msg_mission_item_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _item);
}

- (uint16_t)sequenceNumber
{
    return _item->seq;
}

- (void)setSequenceNumber:(uint16_t)sequenceNumber
{
    _item->seq = sequenceNumber;
    mavlink_msg_mission_item_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _item);
}

- (uint8_t)targetComponent
{
    return _item->target_component;
}

- (void)setTargetComponent:(uint8_t)target_component
{
    _item->target_component = target_component;
    mavlink_msg_mission_item_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _item);
}

- (uint8_t)targetSystem
{
    return _item->target_system;
}

- (void)setTargetSystem:(uint8_t)target_system
{
    _item->target_system = target_system;
    mavlink_msg_mission_item_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _item);
}

// TODO: Other properties


@end
