//
//  FCSPlane.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/10/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSGoogleElevation.h"
#import "FCSWorkerBee.h"
#import "FCSMessageHandlerMissionTranferor.h"

@interface FCSWorkerBee ()

@property NSMutableSet *links;

@property FCSMessageHandlerMissionTranferor *missionTransfer;

@end

/**
 *  A dictionary with keys systemID, subkey componentID, values bees
 */
static NSMutableDictionary *bees;

@implementation FCSWorkerBee

#pragma mark - Class methods

+ (instancetype)beeWithSystemID:(uint8_t)systemID componentID:(uint8_t)componentID
{
    if(nil == bees)
    {
        bees = [NSMutableDictionary dictionaryWithCapacity:1];
    }

    NSMutableDictionary *subDict = [bees objectForKey:[NSNumber numberWithChar:(char)systemID]];
    if(nil == subDict)
    {
        subDict = [NSMutableDictionary dictionaryWithCapacity:1];
        [bees setObject:subDict forKey:[NSNumber numberWithChar:(char)systemID]];
    }

    FCSWorkerBee *bee = [subDict objectForKey:[NSNumber numberWithChar:(char)componentID]];
    if(nil == bee)
    {
        bee = [[FCSWorkerBee alloc] init];
        bee.systemID = systemID;
        bee.componentID = componentID;
        NSLog(@"Created new bee: %@)", bee);
        [subDict setObject:bee forKey:[NSNumber numberWithChar:(char)componentID]];
    }

    return bee;
}

#pragma mark - Instance lifecycle

- (instancetype)init
{
    self = [super init];

    self.links = [NSMutableSet setWithCapacity:1];

    return self;
}

- (void)dealloc
{
    // Close all the links
    for (FCSConnectionLink *link in self.links)
    {
        link.connected = NO;
    }
}

#pragma mark - Link handling

- (void)addConnection:(FCSConnectionLink *)link
{
    [self.links addObject:link];
    // Register for notification of closure
    
}

- (void)opened:(FCSConnectionLink *)link
{
    @throw [NSException exceptionWithName:@"com.rungie.ShouldNotHappen"
                                   reason:@"This should not happen; links should be open when passed to FCSWorkerBee"
                                 userInfo:nil];
}

- (void)closed:(FCSConnectionLink *)link
{
    [self.links removeObject:link];
}

#pragma mark - Mission I/O

- (void)getMissionFromBeeWithProtocol:(FCSConnectionProtocol *)protocol onLink:(FCSConnectionLink *)link
{
    NSLog(@"Get mission from bee: %@",self);
    // Create a waypoint list transferor
    self.mission = [[FCSMission alloc] init];
    _missionTransfer = [[FCSMessageHandlerMissionTranferor alloc] initWithMission:self.mission withProtocol:protocol forLink:link sysID:self.systemID compID:self.componentID];
}

- (void)sendMissionToBeeWithProtocol:(FCSConnectionProtocol *)protocol onLink:(FCSConnectionLink *)link
{

}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Bee: (0x%02x,0x%02x)", self.systemID, self.componentID];
}

@end
