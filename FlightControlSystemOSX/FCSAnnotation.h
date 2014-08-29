//
//  FCSAnnotation.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/29/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSMAVLinkMissionItemMessage.h"

@import MapKit;


@interface FCSAnnotation : NSObject <MKAnnotation>

@property FCSMAVLinkMissionItemMessage *mission_item;

- (instancetype)initWithMissionItem:(FCSMAVLinkMissionItemMessage *)mission_item;

@end
