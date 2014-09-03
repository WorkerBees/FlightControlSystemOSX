//
//  FCSAnnotation.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/29/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSAnnotation.h"

@interface FCSAnnotation ()

@property NSString *titleBase;

@end

@implementation FCSAnnotation

@synthesize coordinate=_coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
}

- (void)associateView:(MKAnnotationView *)view
{
    NSAssert(view.annotation == self, @"View's annotation is not me!");

    CGPoint handle_offset;
    switch(self.mission_item.command)
    {
        case FCSMAVCMDType_NAV_LAND:
            handle_offset = CGPointMake(-21.25, -29);
            break;
        case FCSMAVCMDType_NAV_WAYPOINT:
            handle_offset = CGPointMake(0, -30);
            break;
        case FCSMAVCMDType_NAV_TAKEOFF:
            handle_offset = CGPointMake(17.5, -25);
            break;
        default:
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
        NSString *waypointNumber = [NSString stringWithFormat:@"%u", self.mission_item.sequenceNumber];
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
        switch(self.mission_item.command)
        {
            case FCSMAVCMDType_NAV_LAND:
                textOverlayDrawRect = NSMakeRect(0, 2,
                                                 img.size.width, font.pointSize);
                paragraphStyle.alignment = NSLeftTextAlignment;
                break;
            case FCSMAVCMDType_NAV_WAYPOINT:
                textOverlayDrawRect = NSMakeRect(0, img.size.height/2,
                                                 img.size.width, font.pointSize);
                paragraphStyle.alignment = NSCenterTextAlignment;
                break;
            case FCSMAVCMDType_NAV_TAKEOFF:
                textOverlayDrawRect = NSMakeRect(0, 2,
                                                 img.size.width, font.pointSize);
                paragraphStyle.alignment = NSRightTextAlignment;
                break;
            default:
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
    return [NSString stringWithFormat:@"%u: %@", self.mission_item.sequenceNumber, self.titleBase];
}

- (NSString *)subtitle
{
    return [NSString stringWithFormat:@"Altitude: %0.1fm", self.mission_item.z];
}

- (instancetype)initWithMissionItem:(FCSMAVLinkMissionItemMessage *)mission_item
{
    self = [self init];

    self.mission_item = mission_item;
    switch(self.mission_item.command)
    {
        case FCSMAVCMDType_NAV_LAND: self.titleBase = @"Land"; break;
        case FCSMAVCMDType_NAV_TAKEOFF: self.titleBase = @"Takeoff"; break;
        case FCSMAVCMDType_NAV_WAYPOINT:
        default: self.titleBase = @"Waypoint";
    }

    _coordinate = CLLocationCoordinate2DMake(mission_item.x, mission_item.y);

    return self;
}

@end
