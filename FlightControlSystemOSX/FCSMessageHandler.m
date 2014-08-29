//
//  FCSMessageHandler.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandler_Private.h"

@implementation FCSMessageHandler

- (NSSet *)handledMessages
{
    return self.privateHandledMessages;
}

- (instancetype)init
{
    self = [super init];

    _privateHandledMessages = [NSMutableSet setWithCapacity:5];

    return self;
}

- (void)handleMessage:(NSString *)messageName withSelector:(SEL)selector
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:selector name:messageName object:nil];

    [self.privateHandledMessages addObject:messageName];
}

- (void)stopHandlingMessage:(NSString *)messageName
{
    [self.privateHandledMessages removeObject:messageName];

    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self name:messageName object:nil];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];

    [nc removeObserver:self];
}

@end
