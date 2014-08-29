//
//  FCSMessageHandler.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

// Will listen to the NotificationCenter for message announcements, and will stop listening when dealloc'd (or whenever it wants to)
@interface FCSMessageHandler : NSObject

// The set of messages that are currently being listened for
@property (readonly) NSSet *handledMessages;

@end
