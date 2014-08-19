//
//  FCSConnectionLinkManager.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSConnectionLinkManager_private.h"

#import "FCSSerialLink_private.h"

#import "ORSSerialPortManager.h"
#import "ORSSerialPort.h"

@interface FCSConnectionLinkManager () <NSUserNotificationCenterDelegate>

@property NSMutableSet *links;

@end

@implementation FCSConnectionLinkManager

#pragma mark - Class management methods

- (instancetype)init
{
    self = [super init];

    _links = [NSMutableSet setWithCapacity:5];

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

#pragma mark - FCSConnectionLink delegate methods

- (void)connectionLink:(FCSConnectionLink *)link didReceiveData:(NSData *)input
{
    NSLog(@"Received %lu length data on link %@", input.length, link);
}

- (void)connectionLink:(FCSConnectionLink *)link didEncounterError:(NSError *)error
{
    NSLog(@"Link %@ encountered an error: %@", link, error);
}

- (void)opened:(FCSConnectionLink *)link
{
    NSLog(@"Connected: %@",link);
}

- (void)closed:(FCSConnectionLink *)link
{
    NSLog(@"Disconnected: %@",link);
}

#pragma mark - Manage the list of serial connections

- (void)addUSBSerialPorts:(NSArray *)ports
{
    for (ORSSerialPort *port in ports)
    {
        if([port.name containsString:@"usbserial"])
        {
            NSLog(@"Adding %@ to available ports",port.name);

            [_links addObject:[[FCSSerialLink alloc] initWithLinkManager:self
                                                                withPort:port
                                                            withBaudRate:115200]];
        }
    }
}

- (void)serialPortsWereConnected:(NSNotification *)notification
{
    NSArray *connectedPorts = [[notification userInfo] objectForKey:ORSConnectedSerialPortsKey];
    NSLog(@"Ports were plugged in: %@", connectedPorts);

    [self addUSBSerialPorts:connectedPorts];

    [self postUserNotificationForConnectedPorts:connectedPorts];
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
                [self.links removeObject:link];
            }
        }
    }

    [self postUserNotificationForDisconnectedPorts:disconnectedPorts];
}

- (void)postUserNotificationForConnectedPorts:(NSArray *)connectedPorts
{
    if (!NSClassFromString(@"NSUserNotificationCenter")) return;

    NSUserNotificationCenter *unc = [NSUserNotificationCenter defaultUserNotificationCenter];
    for (ORSSerialPort *port in connectedPorts)
    {
        NSUserNotification *userNote = [[NSUserNotification alloc] init];
        userNote.title = NSLocalizedString(@"Serial Port Connected", @"Serial Port Connected");
        NSString *informativeTextFormat = NSLocalizedString(@"Serial Port %@ was connected to your Mac.", @"Serial port connected user notification informative text");
        userNote.informativeText = [NSString stringWithFormat:informativeTextFormat, port.name];
        userNote.soundName = nil;
        [unc deliverNotification:userNote];
    }
}

- (void)postUserNotificationForDisconnectedPorts:(NSArray *)disconnectedPorts
{
    if (!NSClassFromString(@"NSUserNotificationCenter")) return;

    NSUserNotificationCenter *unc = [NSUserNotificationCenter defaultUserNotificationCenter];
    for (ORSSerialPort *port in disconnectedPorts)
    {
        NSUserNotification *userNote = [[NSUserNotification alloc] init];
        userNote.title = NSLocalizedString(@"Serial Port Disconnected", @"Serial Port Disconnected");
        NSString *informativeTextFormat = NSLocalizedString(@"Serial Port %@ was disconnected from your Mac.", @"Serial port disconnected user notification informative text");
        userNote.informativeText = [NSString stringWithFormat:informativeTextFormat, port.name];
        userNote.soundName = nil;
        [unc deliverNotification:userNote];
    }
}


@end
