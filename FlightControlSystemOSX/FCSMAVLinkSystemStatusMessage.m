//
//  FCSMAVLinkSystemStatusMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkSystemStatusMessage.h"

@interface FCSMAVLinkSystemStatusMessage ()

@property mavlink_sys_status_t *status;

@end

@implementation FCSMAVLinkSystemStatusMessage

- (void)dealloc
{
    free(_status);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _status = malloc(sizeof(*_status));
        bzero(_status, sizeof(*_status));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    _status = malloc(sizeof(mavlink_sys_status_t));
    mavlink_msg_sys_status_decode(self.theMessage, _status);

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"SYSSTATUS"];
}

@end
