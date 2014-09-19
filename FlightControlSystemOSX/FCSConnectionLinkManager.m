//
//  FCSConnectionLinkManager.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSSerialLink_private.h"

#import "FCSConnectionProtocol.h"

#import "FCSConnectionDecoder.h"

#import "ORSSerialPortManager.h"
#import "ORSSerialPort.h"

@interface FCSConnectionLinkManager () <NSUserNotificationCenterDelegate>

@property NSMutableSet *links;
@property NSMutableIndexSet *availableLinkIds;

@end

@implementation FCSConnectionLinkManager

#pragma mark - Class management methods

- (instancetype)init
{
    self = [super init];

    _links = [NSMutableSet setWithCapacity:5];
    _availableLinkIds = [[NSMutableIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, 255)];

    // Search for USB serial ports
    [self addUSBSerialPorts:ORSSerialPortManager.sharedSerialPortManager.availablePorts];

    // Register for serial port changes
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(serialPortsWereConnected:) name:ORSSerialPortsWereConnectedNotification object:nil];
    [nc addObserver:self selector:@selector(serialPortsWereDisconnected:) name:ORSSerialPortsWereDisconnectedNotification object:nil];
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    for (FCSConnectionLink * link in self.links)
    {
        link.connected = NO;
    }
}

- (NSSet *)availableLinks
{
    return self.links;
}

#pragma mark - Manage the list of serial connections

- (void)addUSBSerialPorts:(NSArray *)ports
{
    for (ORSSerialPort *port in ports)
    {
        if([port.name containsString:@"usbserial"])
        {
            NSLog(@"Adding %@ to available ports",port.name);

            FCSConnectionDecoder *newDecoder = [[FCSConnectionDecoder alloc] init];

            FCSConnectionLink *newLink = [[FCSSerialLink alloc] initWithLinkManager:self
                                                                         withLinkID:self.availableLinkIds.firstIndex
                                                                           withPort:port
                                                                       withBaudRate:115200
                                                               withProtocolDelegate:[[FCSConnectionProtocol alloc] initWithDelegate:newDecoder]];
            [self.availableLinkIds removeIndex:self.availableLinkIds.firstIndex];

            [_links addObject:newLink];
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc postNotificationName:FCSNewSerialPortNotification object:self userInfo:@{@"link": newLink}];
        }
    }
}

- (void)serialPortsWereConnected:(NSNotification *)notification
{
    NSArray *connectedPorts = [[notification userInfo] objectForKey:ORSConnectedSerialPortsKey];
    NSLog(@"Ports were plugged in: %@", connectedPorts);

    [self addUSBSerialPorts:connectedPorts];
}

- (void)serialPortsWereDisconnected:(NSNotification *)notification
{
    NSArray *disconnectedPorts = [[notification userInfo] objectForKey:ORSDisconnectedSerialPortsKey];
    NSLog(@"Ports were unplugged: %@", disconnectedPorts);

    for (FCSConnectionLink * link in self.links)
    {
        if(link.type == FCSSerialLinkType)
        {
            if([disconnectedPorts containsObject:((FCSSerialLink *)link).thePort])
            {
                link.connected = NO;
                [self.links removeObject:link];
            }
        }
    }
}

@end
