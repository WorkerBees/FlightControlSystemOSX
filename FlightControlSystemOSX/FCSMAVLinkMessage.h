//
//  FCSMAVLinkMessage.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/20/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSMAVLinkEnumTypes.h"

// Manage mavlink_message_t lifecycle
@interface FCSMAVLinkMessage : NSObject

@property (readonly) mavlink_message_t* theMessage;
@property (readonly) NSString *name;

+ (NSString *)nameForMessageID:(uint8_t)msgid;
+ (instancetype)makeFromMessage:(mavlink_message_t *)message;

- (instancetype)initWithMessage:(mavlink_message_t *)message;

@end

