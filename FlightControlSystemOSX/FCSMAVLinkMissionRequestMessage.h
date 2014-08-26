//
//  FCSMAVLinkMissionRequestMessage.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMessage.h"

@interface FCSMAVLinkMissionRequestMessage : FCSMAVLinkMessage

@property (nonatomic) uint16_t sequenceNumber;
@property (nonatomic) uint8_t targetSystem;
@property (nonatomic) uint8_t targetComponent;


@end
