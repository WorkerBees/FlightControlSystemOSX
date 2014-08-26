//
//  FCSMAVLinkMissionItemMessage.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMessage.h"

@interface FCSMAVLinkMissionItemMessage : FCSMAVLinkMessage

@property (nonatomic) BOOL current;
@property (nonatomic) BOOL autoContinue;
@property (nonatomic) uint16_t sequenceNumber;
@property (nonatomic) uint8_t targetSystem;
@property (nonatomic) uint8_t targetComponent;
@property (nonatomic) FCSMAVFrameType frame;
@property (nonatomic) FCSMAVCMDType command;
@property (nonatomic) float x, y, z;
@property (nonatomic) float param1, param2, param3, param4;

@end
