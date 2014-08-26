//
//  FCSMAVLinkMissionAcknowledgementMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMissionAcknowledgementMessage.h"

@interface FCSMAVLinkMissionAcknowledgementMessage ()

@property mavlink_mission_ack_t *ack;

@end

@implementation FCSMAVLinkMissionAcknowledgementMessage

- (void)dealloc
{
    free(_ack);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _ack = malloc(sizeof(*_ack));
        bzero(_ack, sizeof(*_ack));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _ack = malloc(sizeof(*_ack));
        mavlink_msg_mission_ack_decode(message, _ack);
    }

    return self;
}

- (NSString *)description
{
    NSString *type;
    switch(self.type)
    {
        case FCSMAVMissionAck_ACCEPTED: type = @"Accepted"; break;
        case FCSMAVMissionAck_ERROR: type = @"Error"; break;
        case FCSMAVMissionAck_UNSUPPORTED_FRAME: type = @"Unsupported Frame"; break;
        case FCSMAVMissionAck_UNSUPPORTED: type = @"Unsupported"; break;
        case FCSMAVMissionAck_NO_SPACE: type = @"No Space"; break;
        case FCSMAVMissionAck_INVALID: type = @"Invalid"; break;
        case FCSMAVMissionAck_INVALID_PARAM1: type = @"Invalid Param1"; break;
        case FCSMAVMissionAck_INVALID_PARAM2: type = @"Invalid Param2"; break;
        case FCSMAVMissionAck_INVALID_PARAM3: type = @"Invalid Param3"; break;
        case FCSMAVMissionAck_INVALID_PARAM4: type = @"Invalid Param4"; break;
        case FCSMAVMissionAck_INVALID_PARAM5_X: type = @"Invalid Param5 X"; break;
        case FCSMAVMissionAck_INVALID_PARAM6_Y: type = @"Invalid Param6 Y"; break;
        case FCSMAVMissionAck_INVALID_PARAM7: type = @"Invalid Param7"; break;
        case FCSMAVMissionAck_INVALID_SEQUENCE: type = @"Invalid Sequence"; break;
        case FCSMAVMissionAck_DENIED: type = @"Denied"; break;
        default: type = [NSString stringWithFormat:@"Unknown(%u)", self.type];
    }

    return [NSString stringWithFormat:@"%@: %@ for 0x%02x/0x%02x", self.name, type, self.targetSystem, self.targetComponent];
}

- (FCSMavMissionAckType)type
{
    return _ack->type;
}

- (void)setType:(FCSMavMissionAckType)type
{
    _ack->type = type;
    mavlink_msg_mission_ack_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _ack);
}

- (uint8_t)targetComponent
{
    return _ack->target_component;
}

- (void)setTargetComponent:(uint8_t)target_component
{
    _ack->target_component = target_component;
    mavlink_msg_mission_ack_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _ack);
}

- (uint8_t)targetSystem
{
    return _ack->target_system;
}

- (void)setTargetSystem:(uint8_t)target_system
{
    _ack->target_system = target_system;
    mavlink_msg_mission_ack_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _ack);
}

@end
