//
//  FCSMAVLinkMissionAcknowledgementMessage.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMessage.h"

@interface FCSMAVLinkMissionAcknowledgementMessage : FCSMAVLinkMessage

@property (nonatomic) FCSMavMissionAckType type;
@property (nonatomic) uint8_t targetSystem;
@property (nonatomic) uint8_t targetComponent;

@end
