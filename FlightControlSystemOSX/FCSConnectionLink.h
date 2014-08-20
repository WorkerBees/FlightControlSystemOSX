//
//  FCSConnectionLink.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Foundation;

/*
 * This interface represents the link layer connection; it can be serial, TCP, UDP, from a file, or a simulator
 */

// Match the enum ordering from APM Planner
typedef NS_ENUM(NSUInteger, FCSLinkType)
{
    FCSSerialLinkType,
    FCSTCPLinkType,
    FCSUDPLinkType,
    FCSSIMLinkType,
    FCSUnknownLinkType,
    FCSFileLinkType,
};

@protocol FCSConnectionLinkReadDelegate;
@protocol FCSConnectionLinkStatusDelegate;


////////////////////////////////////////////////////

@interface FCSConnectionLink : NSObject

+ (NSString *)stringForLinkType:(FCSLinkType) type;
+ (FCSLinkType)linkTypeForString:(NSString *) type;

// Read this property to assess connection state; write it to open/close the connection
@property BOOL connected;

// Read this property to assess whether timeouts are enabled; write it to change timeout monitoring.
@property BOOL timeoutsEnabled;

// The type of link
@property (readonly) FCSLinkType type;

// A human-readable name for this connection
@property (readonly) NSString *name;

// A unique ID which is actually in the range 0..255
@property (readonly) NSUInteger linkId;

- (instancetype)initWithType:(FCSLinkType)type
                  withLinkID:(NSUInteger)linkId
                    withName:(NSString *)name;

- (void)writeData:(NSData *)output;

@property id<FCSConnectionLinkReadDelegate> readerDelegate;
@property id<FCSConnectionLinkStatusDelegate> linkStatusDelegate;

@end

////////////////////////////////////////////////////

@protocol FCSConnectionLinkReadDelegate <NSObject>

- (void)connectionLink:(FCSConnectionLink *)link didReceiveData:(NSData *)input;
- (void)connectionLink:(FCSConnectionLink *)link didEncounterError:(NSError *)error;

@end

////////////////////////////////////////////////////

@protocol FCSConnectionLinkStatusDelegate <NSObject>

- (void)closed:(FCSConnectionLink *)link;
- (void)opened:(FCSConnectionLink *)link;

@end

