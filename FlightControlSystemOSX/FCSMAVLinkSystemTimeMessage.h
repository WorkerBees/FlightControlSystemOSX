//
//  FCSMAVLinkSystemTimeMessage.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/21/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMAVLinkMessage.h"

@interface FCSMAVLinkSystemTimeMessage : FCSMAVLinkMessage

@property (nonatomic) uint32_t msSinceBoot;
@property (nonatomic) uint64_t usSinceEpoch;

@end
