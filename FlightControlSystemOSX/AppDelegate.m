//
//  AppDelegate.m
//  dummy
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
            
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"App delegate created and finished launching");
    self.connectionLinkManager = [[FCSConnectionLinkManager alloc] init];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    self.connectionLinkManager = nil;
}

@end
