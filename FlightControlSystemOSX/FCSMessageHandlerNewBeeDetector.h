//
//  FCSMessageHandlerNewBeeDetector.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/17/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandler.h"

/**
 *  Listen for new Bees; identify heartbeat messages that have systemID/componentID that haven't been seen before, then instantiate bees
 */
@interface FCSMessageHandlerNewBeeDetector : FCSMessageHandler

@end
