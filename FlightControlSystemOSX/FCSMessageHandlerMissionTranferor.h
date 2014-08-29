//
//  FCSMessageHandlerWaypointTranferor.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/28/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMessageHandler.h"
#import "FCSMAVLinkMissionItemMessage.h"


@protocol FCSWaypointListReceivedHandler;

@interface FCSMessageHandlerMissionTranferor : FCSMessageHandler

@property id<FCSWaypointListReceivedHandler> delegate;

- (instancetype)initWithDelegate:(id<FCSWaypointListReceivedHandler>)delegate;

@end

@protocol FCSWaypointListReceivedHandler <NSObject>

@optional

- (void)receivedMissionItemCount:(NSUInteger)count;
- (void)receivedMissionItem:(FCSMAVLinkMissionItemMessage *)mission_item;
- (void)receivedMissionItems:(NSArray *)mission_items;

@end