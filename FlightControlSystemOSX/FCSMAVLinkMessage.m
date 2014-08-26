//
//  FCSMAVLinkMessage.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/20/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMessage.h"

#import "FCSMAVLinkMessageSubclasses.h"

static const mavlink_message_info_t message_infos[] = MAVLINK_MESSAGE_INFO;
static NSMutableDictionary *names = nil;

@implementation FCSMAVLinkMessage

+ (void)fillNames
{
    names = [NSMutableDictionary dictionaryWithCapacity:256];
    for(unsigned char i=0; i<255; i++)
    {
        NSString *newName = [NSString stringWithUTF8String:message_infos[i].name];
        [names setObject:newName forKey:[NSNumber numberWithUnsignedChar:i]];
    }
}

+ (NSString *)nameForMessageID:(uint8_t)msgid
{
    if(names == nil) [self fillNames];
    return [names objectForKey:[NSNumber numberWithUnsignedChar:msgid]];
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super init];

    if(self)
    {
        _theMessage = malloc(sizeof(mavlink_message_t));
        memcpy(_theMessage, message, sizeof(mavlink_message_t));
    }

    return self;
}

+ (instancetype)makeFromMessage:(mavlink_message_t *)message
{
    FCSMAVLinkMessage *newMessage;

    switch(message->msgid)
    {
            // System info and whatnot
        case MAVLINK_MSG_ID_HEARTBEAT:
        {
            newMessage = [FCSMAVLinkHeartbeatMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_SYS_STATUS:
        {
            newMessage = [FCSMAVLinkSystemStatusMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_STATUSTEXT:
        {
            newMessage = [FCSMAVLinkStatusTextMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_SYSTEM_TIME:
        {
            newMessage = [FCSMAVLinkSystemTimeMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_MEMINFO:
        {
            newMessage = [FCSMAVLinkMemInfoMessage alloc];
            break;
        }

            // Mission stuff
        case MAVLINK_MSG_ID_MISSION_REQUEST_LIST:
        {
            newMessage = [FCSMAVLinkMissionRequestListMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_MISSION_COUNT:
        {
            newMessage = [FCSMAVLinkMissionCountMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_MISSION_REQUEST:
        {
            newMessage = [FCSMAVLinkMissionRequestMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_MISSION_ITEM:
        {
            newMessage = [FCSMAVLinkMissionItemMessage alloc];
            break;
        }
        case MAVLINK_MSG_ID_MISSION_ACK:
        {
            newMessage = [FCSMAVLinkMissionAcknowledgementMessage alloc];
            break;
        }

        case MAVLINK_MSG_ID_COMMAND_LONG:
        case MAVLINK_MSG_ID_COMMAND_ACK:
        case MAVLINK_MSG_ID_PARAM_SET:
        case MAVLINK_MSG_ID_PARAM_VALUE:
        case MAVLINK_MSG_ID_DATA_STREAM:
        case MAVLINK_MSG_ID_GPS_STATUS:
        case MAVLINK_MSG_ID_HIGHRES_IMU:
        default:
            newMessage = [FCSMAVLinkMessage alloc];
            break;
    }

    newMessage = [newMessage initWithMessage:message];

    return newMessage;
}

- (NSString *)description
{
    // Default for messages not specifically parsed in detail
    mavlink_message_info_t info = message_infos[self.theMessage->msgid];

    return [NSString stringWithFormat:@"(%s)", info.name];
}

- (NSString *)name
{
    return [FCSMAVLinkMessage nameForMessageID:self.theMessage->msgid];
}

- (void)dealloc
{
    free(_theMessage);
}

@end

