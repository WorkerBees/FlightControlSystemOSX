//
//  AppDelegate.m
//  dummy
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "AppDelegate.h"

#import "FCSMessageHandlerLogger.h"
#import "FCSMessageHandlerMissionTranferor.h"

@interface AppDelegate () <FCSWaypointListReceivedHandler>

@property NSMutableSet *handlers;

@end

@implementation AppDelegate

- (instancetype)init
{
    self = [super init];
    _handlers = [NSMutableSet setWithCapacity:20];
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"App delegate created and finished launching");
    self.connectionLinkManager = [[FCSConnectionLinkManager alloc] init];

    // Create a logger
    [self.handlers addObject:[[FCSMessageHandlerLogger alloc] init]];

    // Create a waypoint list transferor
    [self.handlers addObject:[[FCSMessageHandlerMissionTranferor alloc] initWithDelegate:self]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self.handlers removeAllObjects];
    self.connectionLinkManager = nil;
}

- (void)receivedMissionItemCount:(NSUInteger)count
{
    NSLog(@"MAV says it will send %lul mission items", (unsigned long)count);
}

- (void)receivedMissionItem:(FCSMAVLinkMissionItemMessage *)mission_item
{
    NSLog(@"Got mission item: %@", mission_item);
}

- (void)receivedMissionItems:(NSArray *)mission_items
{
    NSLog(@"Got all mission items: %@", mission_items);
}

@end
