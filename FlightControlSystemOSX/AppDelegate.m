//
//  AppDelegate.m
//  dummy
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "AppDelegate.h"

#import "FCSMessageHandlerLogger.h"
#import "FCSMessageHandlerNewBeeDetector.h"

@interface AppDelegate ()

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
    self.connectionLinkManager = [[FCSConnectionLinkManager alloc] init];

    // Create a logger
    [self.handlers addObject:[[FCSMessageHandlerLogger alloc] init]];

    // Detect new Bees
    [self.handlers addObject:[[FCSMessageHandlerNewBeeDetector alloc] init]];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self.handlers removeAllObjects];
    self.connectionLinkManager = nil;
}

@end
