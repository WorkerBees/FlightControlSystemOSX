//
//  FCSSerialLink_private.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#ifndef FlightControlSystemOSX_FCSSerialLink_private_h
#define FlightControlSystemOSX_FCSSerialLink_private_h

#import "FCSSerialLink.h"
#import "ORSSerialPort.h"

@interface FCSSerialLink () <ORSSerialPortDelegate>

- (instancetype)initWithLinkManager:(FCSConnectionLinkManager *)manager
                         withLinkID:(NSUInteger)id
                           withPort:(ORSSerialPort *)port
                       withBaudRate:(NSUInteger)baudRate
               withProtocolDelegate:(id<FCSConnectionLinkReadDelegate>)protocolDelegate;

@property ORSSerialPort *thePort;

@end

#endif
