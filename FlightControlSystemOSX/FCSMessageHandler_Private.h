//
//  FCSMessageHandler_Private.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandler.h"

@interface FCSMessageHandler ()

@property (nonatomic) NSMutableSet *privateHandledMessages;

- (void)handleMessage:(NSString *)messageName withSelector:(SEL)selector;
- (void)stopHandlingMessage:(NSString *)messageName;

@end