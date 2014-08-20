//
//  FCSConnectionProtocol.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSConnectionLink.h"
#import "mavlink.h"

@protocol FCSMAVLinkMessageReceivedDelegate;

// Manage mavlink_message_t lifecycle
@interface FCSMAVLinkMessage : NSObject

@property (readonly) mavlink_message_t* theMessage;

- (instancetype)initWithMessage:(mavlink_message_t *)message;

@end

// This interface receives bytes and builds up the MAVlink messages that are there.  It will signal back to its delegate when the messages are complete

@interface FCSConnectionProtocol : NSObject <FCSConnectionLinkReadDelegate>

+ (uint8_t)systemID;
+ (uint8_t)componentID;

- (instancetype)initWithDelegate:(id<FCSMAVLinkMessageReceivedDelegate>)delegate;

- (void)sendMessage:(FCSMAVLinkMessage *)message onLink:(FCSConnectionLink *)link;
@property id<FCSMAVLinkMessageReceivedDelegate> delegate;


@end


@protocol FCSMAVLinkMessageReceivedDelegate <NSObject>

- (void)link:(FCSConnectionLink *)link receivedMAVLinkMessage:(FCSMAVLinkMessage *)message;

@end