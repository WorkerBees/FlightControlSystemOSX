//
//  FCSMAVLinkMissionRequestMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMissionRequestMessage.h"

@interface FCSMAVLinkMissionRequestMessage ()

@property mavlink_mission_request_t *request;

@end

@implementation FCSMAVLinkMissionRequestMessage

- (void)dealloc
{
    free(_request);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _request = malloc(sizeof(*_request));
        bzero(_request, sizeof(*_request));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super init];

    if(self)
    {
        _request = malloc(sizeof(*_request));
        mavlink_msg_mission_request_decode(message, _request);
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %u for 0x%02x/0x%02x", self.name, _request->seq, _request->target_system, _request->target_component];
}

- (uint16_t)sequenceNumber
{
    return _request->seq;
}

- (void)setSequenceNumber:(uint16_t)sequenceNumber
{
    _request->seq = sequenceNumber;
    mavlink_msg_mission_request_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _request);
}

- (uint8_t)targetComponent
{
    return _request->target_component;
}

- (void)setTargetComponent:(uint8_t)target_component
{
    _request->target_component = target_component;
    mavlink_msg_mission_request_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _request);
}

- (uint8_t)targetSystem
{
    return _request->target_system;
}

- (void)setTargetSystem:(uint8_t)target_system
{
    _request->target_system = target_system;
    mavlink_msg_mission_request_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _request);
}


@end
