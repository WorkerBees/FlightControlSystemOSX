//
//  FCSMAVLinkMissionCountMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMissionCountMessage.h"

@interface FCSMAVLinkMissionCountMessage ()

@property mavlink_mission_count_t *mission_count;

@end


@implementation FCSMAVLinkMissionCountMessage

- (void)dealloc
{
    free(_mission_count);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _mission_count = malloc(sizeof(*_mission_count));
        bzero(_mission_count, sizeof(*_mission_count));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _mission_count = malloc(sizeof(*_mission_count));
        mavlink_msg_mission_count_decode(message, _mission_count);
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@: %u for 0x%02x/0x%02x",
            self.name,
            _mission_count->count,
            _mission_count->target_system,
            _mission_count->target_component];
}

- (uint16_t)count
{
    return _mission_count->count;
}

- (void)setCount:(uint16_t)count
{
    _mission_count->count = count;
    mavlink_msg_mission_count_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _mission_count);
}

- (uint8_t)targetComponent
{
    return _mission_count->target_component;
}

- (void)setTargetComponent:(uint8_t)target_component
{
    _mission_count->target_component = target_component;
    mavlink_msg_mission_count_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _mission_count);
}

- (uint8_t)targetSystem
{
    return _mission_count->target_system;
}

- (void)setTargetSystem:(uint8_t)target_system
{
    _mission_count->target_system = target_system;
    mavlink_msg_mission_count_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _mission_count);
}

@end
