//
//  FCSMissionItem.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/11/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

#import "FCSMAVLinkMissionItemMessage.h"
@class FCSMissionItem;

/**
 *  This class represents a mission.  It can be read from a UAV or sent to one.  Individual mission item types will create categories to extend this class to provide methods for creating each mission item type without starting from a FCSMAVLinkMissionItemMessage
 */
@interface FCSMission : NSObject

/**
 *  The sequence of mission items.
 *
 *  An array of individual mission items; each mission item has its own class, but all implement the protocol FCSMissionItem
 */
@property (readonly) NSArray *items;

/**
 *  Make a new mission item from the given message.  Insert into this mission at the specified position, and return it.
 *
 *  @param message  The encoded mission item to add
 *
 *  @return         The newly-created mission item
 */
- (FCSMissionItem *)makeMissionItemFromMessage:(FCSMAVLinkMissionItemMessage *)message;

/**
 *  Remove a mission item from the mission.  Any references to this mission item should be considered stale and dropped.
 *
 *  @param index The position of the mission item to delete in the mission list
 */
- (void)removeMissionItemAtIndex:(NSUInteger)index;

/**
 *  Move a mission item from one position to another
 *
 *  @param source The starting position of the item to move
 *  @param dest   Where the item should end up in the list after the move.
 */
- (void)moveMissionItemFromIndex:(NSUInteger)source toIndex:(NSUInteger)dest;

@end
