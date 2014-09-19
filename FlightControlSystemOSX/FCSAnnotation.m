//
//  FCSAnnotation.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/29/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSMissionItemLand.h"
#import "FCSMissionItemTakeoff.h"
#import "FCSMissionItemWaypoint.h"
#import "FCSMissionItem_Private.h"
#import "FCSAnnotation.h"

@interface FCSAnnotation ()

@property NSString *titleBase;

@end

@implementation FCSAnnotation

@synthesize coordinate=_coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;

    if([self.mission_item isKindOfClass:[FCSMissionItemWaypoint class]])
    {
        ((FCSMissionItemWaypoint *)self.mission_item).position = newCoordinate;
    }
    else if([self.mission_item isKindOfClass:[FCSMissionItemLand class]])
    {
        ((FCSMissionItemLand *)self.mission_item).position = newCoordinate;
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Annotation: %@", self.mission_item];
}

- (void)associateView:(MKAnnotationView *)view
{
    NSAssert(view.annotation == self, @"View's annotation is not me!");

    CGPoint handle_offset;
    if([self.mission_item isKindOfClass:[FCSMissionItemLand class]])
    {
        handle_offset = CGPointMake(-21.25, -29);
    }
    else if([self.mission_item isKindOfClass:[FCSMissionItemWaypoint class]])
    {
        handle_offset = CGPointMake(0, -30);

    }
    else if([self.mission_item isKindOfClass:[FCSMissionItemTakeoff class]])
    {
        handle_offset = CGPointMake(17.5, -25);
    }
    else
    {
        @throw [NSException exceptionWithName:@"Bad mission item"
                                       reason:@"You should not have a mission item of that type here!"
                                     userInfo:@{@"mission_item":self.mission_item}];
    }

    // Search for cached image with waypoint number already scribbled on it
    NSImage *img = [NSImage imageNamed:self.title];
    if(!img)
    {
        img = [[NSImage imageNamed:self.titleBase] copy];
        // We need to overlay on the image the waypoint number
        [img lockFocus];
        NSString *waypointNumber = [NSString stringWithFormat:@"%lu", (unsigned long)self.mission_item.sequenceNumber];
        NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        NSFont *font = [NSFont systemFontOfSize:24];
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [NSColor blackColor];
        shadow.shadowBlurRadius = 3.0;
        shadow.shadowOffset = CGSizeMake(0, 0);

        NSDictionary * attributes = @{ NSParagraphStyleAttributeName: paragraphStyle,
                                       NSFontAttributeName: font,
                                       NSForegroundColorAttributeName: [NSColor whiteColor],
                                       NSShadowAttributeName: shadow,
                                       };

        NSRect textOverlayDrawRect;
        if([self.mission_item isKindOfClass:[FCSMissionItemLand class]])
        {
            textOverlayDrawRect = NSMakeRect(0, 2,
                                             img.size.width, font.pointSize);
            paragraphStyle.alignment = NSLeftTextAlignment;
        }
        else if([self.mission_item isKindOfClass:[FCSMissionItemWaypoint class]])
        {
            textOverlayDrawRect = NSMakeRect(0, img.size.height/2,
                                             img.size.width, font.pointSize);
            paragraphStyle.alignment = NSCenterTextAlignment;
        }
        else if([self.mission_item isKindOfClass:[FCSMissionItemTakeoff class]])
        {
            textOverlayDrawRect = NSMakeRect(0, 2,
                                             img.size.width, font.pointSize);
            paragraphStyle.alignment = NSRightTextAlignment;
        }
        else
        {
            @throw [NSException exceptionWithName:@"Bad mission item"
                                           reason:@"You should not have a mission item of that type here!"
                                         userInfo:@{@"mission_item":self.mission_item}];
        }

        [waypointNumber drawInRect:textOverlayDrawRect withAttributes:attributes];
        [img unlockFocus];

        // Now cache it
        img.name = self.title;
    }

    view.image = img;
    view.centerOffset = handle_offset;
    view.canShowCallout = YES;
    view.draggable = YES;
}

- (NSString *)title
{
    return [NSString stringWithFormat:@"%lu: %@", (unsigned long)self.mission_item.sequenceNumber, self.titleBase];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"Altitude: %0.1fm", [[self.mission_item.parameters objectForKey:ALTITUDE] floatValue]];
}

- (instancetype)initWithMissionItem:(FCSMissionItem *)mission_item
{
    self = [self init];

    self.mission_item = mission_item;
    if([self.mission_item isKindOfClass:[FCSMissionItemLand class]])
    {
        self.titleBase = @"Land";
        _coordinate = ((FCSMissionItemLand *)self.mission_item).position;
    }
    else if([self.mission_item isKindOfClass:[FCSMissionItemTakeoff class]])
    {
        self.titleBase = @"Takeoff";
        _coordinate = CLLocationCoordinate2DMake([self.mission_item param:Param5], [self.mission_item param:Param6]);
    }
    else
    {
        self.titleBase = @"Waypoint";
        _coordinate = ((FCSMissionItemWaypoint *)self.mission_item).position;
    }

    return self;
}

@end
