//
//  FCSMissionItem.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/12/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSMission.h"
#import "FCSMAVLinkMissionItemMessage.h"

/**
 *  Base class for mission items.  This class should not be instantiated directly.  Subclasses will be returned by [FCSMission -makeMissionItemFromMessage: atIndex:].  Mission items should not exist outside of the context of a mission.
 
    All FCSMissionItem parameters are in WGS-84 global coordinates.  Other MAVLink frames will be converted to WGS-84.
 */
@interface FCSMissionItem : NSObject

/**
 *  The sequence number of this mission item in the mission.  To change sequence numbers, the correct way is to re-order the FCSMission.items array.  This property will just track the position of this mission item within that parent mission's array.  If this mission item has been removed from a mission, its sequence number will be NSNotFound
 */
@property (readonly) NSUInteger sequenceNumber;

/**
 *  The name of this mission item.  Generally this will just be a (localized) display name for the type of mission item, eg. @"Waypoint" or @"Change speed", etc.
 */
@property NSString *name;

/**
 *  The parameters for this mission item.  The keys will be display names for the parameters, and they will represent the particular mission item type's meaning for those parameters.  ie they will not be @"param1" or @"x", they will instead be @"Speed (m/s)" or @"Latitude", etc.
 */
@property (readonly) NSDictionary *parameters;

/**
 *  Create an encoding of this mission item as a MAVLink message which could then be sent to a device.
 *  @warning The target system and component will both be 0; they must be set before the message is actually sent to a device.
 */
@property (readonly) FCSMAVLinkMissionItemMessage *message;

/**
 *  Initialize the mission item with the specified message.
 *
 *  @param message The message to use in initializing the mission item.  This message is not retained by the mission item.
 *
 *  @return The initialized instance
 */
- (instancetype)initWithMessage:(FCSMAVLinkMissionItemMessage *)message;

@end
