//
//  FCSConnectionDecoder.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSConnectionDecoder.h"

@implementation FCSConnectionDecoder

- (void)protocol:(FCSConnectionProtocol *)protocol link:(FCSConnectionLink *)link receivedMAVLinkMessage:(FCSMAVLinkMessage *)message;
{
    // Broadcast that we received this message
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *userInfo = @{@"link": link, @"message" : message, @"protocol": protocol};
    [nc postNotificationName:message.name object:self userInfo:userInfo];
    NSLog(@"Broadcast: %@", message.name);
}


@end
