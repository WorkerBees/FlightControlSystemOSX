//
//  FCSSerialLink.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSSerialLink_private.h"

@interface FCSSerialLink ()

@end

@implementation FCSSerialLink

#pragma mark - Property accessors

- (FCSLinkType) type { return FCSSerialLinkType; }
- (NSString *) name { NSAssert(self.thePort!= nil,@"Th port is nil!"); return self.thePort.name; }
- (BOOL) connected { NSAssert(self.thePort!= nil,@"Th port is nil!"); return self.thePort.isOpen; }

- (void) setConnected:(BOOL)connected
{
    NSAssert(self.thePort != nil, @"The port is nil!");
    if(connected && !self.thePort.isOpen)
    {
        [self.thePort open];
    }
    else if (!connected && self.thePort.isOpen)
    {
        [self.thePort close];
    }
}

#pragma mark - Class management methods

- (NSString *)description
{
    NSString *connectedString;
    if(self.connected)
    {
        connectedString = @"Connected";
    }
    else
    {
        connectedString = @"Disconnected";
    }

    return [NSString stringWithFormat:@"%@ - %@ - %@", [FCSConnectionLink stringForLinkType:self.type], self.name, connectedString];
}

- (instancetype)initWithLinkManager:(FCSConnectionLinkManager *)manager withPort:(ORSSerialPort *)port withBaudRate:(NSUInteger)baudRate
{
    self.readerDelegate = manager;
    self.linkStatusDelegate = manager;
    self.thePort = port;

    self.thePort.delegate = self;
    self.thePort.baudRate = [NSNumber numberWithUnsignedInteger:baudRate];

    return self;
}

- (void)dealloc
{
    self.readerDelegate = nil;
    self.linkStatusDelegate = nil;

    self.thePort.delegate = nil;
}

#pragma mark - I/O on the port

- (void) writeData:(NSData *)output
{
    [self.thePort sendData:output];
}

- (void)serialPort:(ORSSerialPort *)serialPort didReceiveData:(NSData *)data
{
    if(self.readerDelegate)
    {
        [self.readerDelegate connectionLink:self didReceiveData:data];
    }
}

- (void)serialPort:(ORSSerialPort *)serialPort didEncounterError:(NSError *)error
{
    if(self.readerDelegate)
    {
        [self.readerDelegate connectionLink:self didEncounterError:error];
    }
}

- (void)serialPortWasClosed:(ORSSerialPort *)serialPort
{
    if(self.linkStatusDelegate)
    {
        [self.linkStatusDelegate closed:self];
    }
}

- (void)serialPortWasOpened:(ORSSerialPort *)serialPort
{
    if(self.linkStatusDelegate)
    {
        [self.linkStatusDelegate opened:self];
    }
}

#pragma mark - Port physically removed

- (void)serialPortWasRemovedFromSystem:(ORSSerialPort *)serialPort
{
    NSLog(@"Serial port was removed from system: %@",serialPort.name);
    // We are about to get killed by our manager
}

@end
