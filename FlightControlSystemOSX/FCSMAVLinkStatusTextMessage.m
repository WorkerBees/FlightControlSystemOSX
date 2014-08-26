//
//  FCSMAVLinkStatusTextMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkStatusTextMessage.h"

@interface FCSMAVLinkStatusTextMessage ()

@property mavlink_statustext_t *statustext;

@end

@implementation FCSMAVLinkStatusTextMessage

- (void)dealloc
{
    free(_statustext);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _statustext = malloc(sizeof(*_statustext));
        bzero(_statustext, sizeof(*_statustext));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    _statustext = malloc(sizeof(mavlink_statustext_t));
    mavlink_msg_statustext_decode(self.theMessage, _statustext);

    return self;
}

- (NSString *)description
{
    NSString *severity;
    switch(_statustext->severity)
    {
        case MAV_SEVERITY_EMERGENCY: severity = @"EMERGENCY"; break;
        case MAV_SEVERITY_ALERT: severity = @"ALERT"; break;
        case MAV_SEVERITY_CRITICAL: severity = @"CRITICAL"; break;
        case MAV_SEVERITY_ERROR: severity = @"ERROR"; break;
        case MAV_SEVERITY_WARNING: severity = @"WARNING"; break;
        case MAV_SEVERITY_NOTICE: severity = @"NOTICE"; break;
        case MAV_SEVERITY_INFO: severity = @"INFO"; break;
        case MAV_SEVERITY_DEBUG: severity = @"DEBUG"; break;
        default:
            severity = @"Unknown";
    }
    return [NSString stringWithFormat:@"%@: [%@] %s", self.name, severity, _statustext->text];
}


@end
