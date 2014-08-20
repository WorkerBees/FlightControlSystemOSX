//
//  FCSConnectionProtocol.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSConnectionProtocol.h"

static const mavlink_message_info_t message_infos[] = MAVLINK_MESSAGE_INFO;

@implementation FCSMAVLinkMessage

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super init];

    _theMessage = malloc(sizeof(mavlink_message_t));
    memcpy(_theMessage, message, sizeof(mavlink_message_t));

    return self;
}

- (NSString *)description
{
    mavlink_message_info_t info = message_infos[self.theMessage->msgid];
    NSString *result = [NSString stringWithFormat:@"(%s) sys:%02x comp:%02x seq:%02x", info.name,
                                                                                       self.theMessage->sysid,
                                                                                       self.theMessage->compid,
                                                                                       self.theMessage->seq];

    return result;
}

- (void)dealloc
{
    free(_theMessage);
}

@end


@interface FCSConnectionProtocol ()

// A dictionary with keys of systemID; values are dictionary with (key componentID; value lastSequenceNumber
@property NSMutableDictionary *lastIndex;

@end

@implementation FCSConnectionProtocol

+ (uint8_t)systemID { return 252; }
+ (uint8_t)componentID { return 1; }

- (instancetype)initWithDelegate:(id<FCSMAVLinkMessageReceivedDelegate>)delegate
{
    self = [super init];

    _delegate = delegate;
    _lastIndex = [NSMutableDictionary dictionaryWithCapacity:256];

    return self;
}

- (void)sendMessage:(FCSMAVLinkMessage *)message onLink:(FCSConnectionLink *)link
{
    // Create buffer
    uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
    // Write message into buffer, prepending start sign
    int len = mavlink_msg_to_send_buffer(buffer, message.theMessage);
    static uint8_t messageKeys[256] = MAVLINK_MESSAGE_CRCS;
    mavlink_finalize_message_chan(message.theMessage,
                                  FCSConnectionProtocol.systemID,
                                  FCSConnectionProtocol.componentID,
                                  (uint8_t)link.linkId,
                                  message.theMessage->len,
                                  messageKeys[message.theMessage->msgid]);

    // If link is connected
    if (link.connected)
    {
        // Send the portion of the buffer now occupied by the message
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)len];
        [link writeData:data];
    }
    else
    {
        NSLog(@"Link is not connected: will not send %@", message);
    }
}

- (void)connectionLink:(FCSConnectionLink *)link didReceiveData:(NSData *)input
{
    mavlink_message_t message;
    mavlink_status_t status;

    for(NSUInteger pos=0; pos < input.length; pos++)
    {
        uint8_t byte;
        [input getBytes:&byte range:NSMakeRange(pos, 1)];
        unsigned int decodeState = mavlink_parse_char((uint8_t)link.linkId, byte, &message, &status);
        if (decodeState == 1)
        {
            if(message.msgid == MAVLINK_MSG_ID_PING)
            {
                // process ping requests (tgt_system and tgt_comp must be zero)
                mavlink_ping_t ping;
                mavlink_msg_ping_decode(&message, &ping);
                if(!ping.target_system && !ping.target_component)
                {
                    mavlink_message_t msg;
                    mavlink_msg_ping_pack(FCSConnectionProtocol.systemID,
                                          FCSConnectionProtocol.componentID,
                                          &msg,
                                          ping.time_usec,
                                          ping.seq,
                                          message.sysid,
                                          message.compid);
                    NSLog(@"Replying to ping");
                    [self sendMessage:[[FCSMAVLinkMessage alloc] initWithMessage:&msg] onLink:link];
                }
            }

            uint8_t expectedSeq;
            NSMutableDictionary *sysDict = (NSMutableDictionary *)[self.lastIndex objectForKey:[NSNumber numberWithUnsignedChar:message.sysid]];
            if(sysDict != nil)
            {
                NSNumber *num = [sysDict objectForKey:[NSNumber numberWithUnsignedChar:message.compid]];
                if(num != nil)
                {
                    expectedSeq = num.unsignedCharValue + 1;
                }
                else
                {
                    [sysDict setObject:[NSNumber numberWithUnsignedChar:message.seq]
                                forKey:[NSNumber numberWithUnsignedChar:message.compid]];
                    expectedSeq = message.seq;
                }
            }
            else
            {
                sysDict = [NSMutableDictionary dictionaryWithDictionary:@{ [NSNumber numberWithUnsignedChar:message.compid]: [NSNumber numberWithUnsignedChar:message.seq] }];
                [self.lastIndex setObject:sysDict forKey:[NSNumber numberWithUnsignedChar:message.sysid]];
                expectedSeq = message.seq;
            }

            if(message.seq != expectedSeq)
            {
                // Determine how many messages were skipped accounting for 0-wraparound
                int16_t lostMessages = message.seq - expectedSeq;
                if (lostMessages >= 0)
                {
                    NSLog(@"Lost %u messages for sys %u, comp %u: expected sequence %u but received %u",
                          lostMessages,
                          message.sysid,
                          message.compid,
                          expectedSeq,
                          message.seq);
                }
            }

            // Update the last sequence ID
            [[self.lastIndex objectForKey:[NSNumber numberWithUnsignedChar:message.sysid]]
                    setObject:[NSNumber numberWithUnsignedChar:message.seq]
                       forKey:[NSNumber numberWithUnsignedChar:message.compid]];

            // Now send out the message
            if(self.delegate)
            {
                // FCSMAVLinkMessage init method will copy the message contents off the stack into a managed heap object
                [self.delegate link:link receivedMAVLinkMessage:[[FCSMAVLinkMessage alloc] initWithMessage:&message]];
            }
        }
    }
}

- (void)connectionLink:(FCSConnectionLink *)link didEncounterError:(NSError *)error
{
    NSLog(@"Link %@ encountered an error: %@", link, error);
}


@end
