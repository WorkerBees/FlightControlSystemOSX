//
//  FCSMAVLinkMemInfoMessag.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/26/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMemInfoMessage.h"

@interface FCSMAVLinkMemInfoMessage ()

@property mavlink_meminfo_t *meminfo;

@end

@implementation FCSMAVLinkMemInfoMessage

- (void)dealloc
{
    free(_meminfo);
}

- (instancetype)init
{
    self = [super init];

    if(self)
    {
        _meminfo = malloc(sizeof(*_meminfo));
        bzero(_meminfo, sizeof(*_meminfo));
    }

    return self;
}

- (instancetype)initWithMessage:(mavlink_message_t *)message
{
    self = [super initWithMessage:message];

    if(self)
    {
        _meminfo = malloc(sizeof(*_meminfo));
        mavlink_msg_meminfo_decode(message, _meminfo);
    }

    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"MEMINFO: Free: %u; BRKVAL: %u", _meminfo->freemem, _meminfo->brkval];
}

- (uint16_t)freemem
{
    return _meminfo->freemem;
}

- (void)setFreemem:(uint16_t)freemem
{
    _meminfo->freemem = freemem;
    mavlink_msg_meminfo_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _meminfo);
}

- (uint16_t)brkval
{
    return _meminfo->brkval;
}

- (void)setBrkval:(uint16_t)brkval
{
    _meminfo->brkval = brkval;
    mavlink_msg_meminfo_encode(self.theMessage->sysid, self.theMessage->compid, self.theMessage, _meminfo);
}

@end
