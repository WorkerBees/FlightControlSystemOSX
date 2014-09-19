//
//  FCSMessageHandler_Private.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandler.h"

 /**
 *  Extensions for handlers themselves to be able to call
 */
@interface FCSMessageHandler ()

@property (nonatomic) NSMutableSet *privateHandledMessages;

/**
 *  Start handling messages of a given type, using the specified selector
 *
 *  @param messageName The messages to handle
 *  @param selector    Selector to call back when the message is received
 */
- (void)handleMessage:(NSString *)messageName withSelector:(SEL)selector;


/**
 *  Stop listening for a message
 *
 *  @param messageName The message to no longer handle
 */
- (void)stopHandlingMessage:(NSString *)messageName;

@end