//
//  FCSAnnotation.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/29/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSMissionItem.h"

@import MapKit;


@interface FCSAnnotation : NSObject <MKAnnotation>

@property FCSMissionItem *mission_item;

- (instancetype)initWithMissionItem:(FCSMissionItem *)mission_item;
- (void)associateView:(MKAnnotationView *)view;

@end
