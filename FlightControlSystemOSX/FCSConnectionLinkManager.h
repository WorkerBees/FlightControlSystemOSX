//
//  FCSConnectionLinkManager.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSConnectionLink.h"

// Manages creating connections to remote endpoints

@interface FCSConnectionLinkManager : NSObject

// The set of available connections
// A set of NSObjects that obey the FCSConnectionLink protocol
@property (readonly) NSSet *availableLinks;

@end
