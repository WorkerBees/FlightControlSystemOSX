//
//  FCSMAVLinkMissionRequestListMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMissionRequestListMessage.h"

@interface FCSMAVLinkMissionRequestListMessage ()

@property mavlink_mission_request_list_t *request_list;

@end

@implementation FCSMAVLinkMissionRequestListMessage

- (void)dealloc
{
    free(_request_list);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _request_list = malloc(sizeof(*_request_list));
        bzero(_request_list, sizeof(*_request_list));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _request_list = malloc(sizeof(*_request_list));
        mavlink_msg_mission_request_list_decode(message, _request_list);
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: 0x%02x/0x%02x", self.name, _request_list->target_system, _request_list->target_component];
}

- (uint8_t)targetComponent
{
    return _request_list->target_component;
}

- (void)setTargetComponent:(uint8_t)target_component
{
    _request_list->target_component = target_component;
    mavlink_msg_mission_request_list_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _request_list);
}

- (uint8_t)targetSystem
{
    return _request_list->target_system;
}

- (void)setTargetSystem:(uint8_t)target_system
{
    _request_list->target_system = target_system;
    mavlink_msg_mission_request_list_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _request_list);
}


@end
