//
//  FCSMAVLinkSystemTimeMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkSystemTimeMessage.h"

@interface FCSMAVLinkSystemTimeMessage ()

@property mavlink_system_time_t *system_time;

@end

@implementation FCSMAVLinkSystemTimeMessage

- (void)dealloc
{
    free(_system_time);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _system_time = malloc(sizeof(*_system_time));
        bzero(_system_time, sizeof(*_system_time));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _system_time = malloc(sizeof(*_system_time));
        mavlink_msg_system_time_decode(message, _system_time);
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"SYSTEMTIME: Boot - %0.3f; Stamp - %0.6f",
            ((float)_system_time->time_boot_ms/1000),
            ((float)_system_time->time_unix_usec)/1000000];
}

- (uint32_t)msSinceBoot
{
    return _system_time->time_boot_ms;
}

- (void)setMsSinceBoot:(uint32_t)msSinceBoot
{
    _system_time->time_boot_ms = msSinceBoot;
    mavlink_msg_system_time_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _system_time);
}

- (uint64_t)usSinceEpoch
{
    return _system_time->time_unix_usec;
}

- (void)setUsSinceEpoch:(uint64_t)usSinceEpoch
{
    _system_time->time_unix_usec = usSinceEpoch;
    mavlink_msg_system_time_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _system_time);
}

@end
