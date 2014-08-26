//
//  FCSConnectionDecoder.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSConnectionDecoder.h"

@implementation FCSConnectionDecoder

- (void)link:(FCSConnectionLink *)link receivedMAVLinkMessage:(FCSMAVLinkMessage *)message
{
    NSLog(@"Received message %@ on link %@", message, link);


    // Broadcast that we received this message
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    NSDictionary *userInfo = @{@"message" : message};
    [nc postNotificationName:message.name object:self userInfo:userInfo];
}


@end