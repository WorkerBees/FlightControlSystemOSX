//
//  FCSConnectionLink_FCSConnectionLink_m.h
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 8/19/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSConnectionLink.h"

@implementation FCSConnectionLink

+ (NSDictionary *)lookup
{
    static NSDictionary *lookup = nil;
    if(lookup == nil)
    {
        lookup = @{
                   [NSNumber numberWithUnsignedInteger:FCSSerialLinkType]: @"Serial",
                   [NSNumber numberWithUnsignedInteger:FCSTCPLinkType]: @"TCP",
                   [NSNumber numberWithUnsignedInteger:FCSUDPLinkType]: @"UDP",
                   [NSNumber numberWithUnsignedInteger:FCSSIMLinkType]: @"Simulation",
                   [NSNumber numberWithUnsignedInteger:FCSUnknownLinkType]: @"Unknown",
                   [NSNumber numberWithUnsignedInteger:FCSFileLinkType]: @"File",
                   };
    }

    return lookup;
}

+ (NSString *)stringForLinkType:(FCSLinkType) type
{
    return NSLocalizedString([self.lookup objectForKey:[NSNumber numberWithUnsignedInteger:type]], nil);
}

+ (FCSLinkType)linkTypeForString:(NSString *) type
{
    __block FCSLinkType result = FCSUnknownLinkType;
    [self.lookup enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
    {
        if([obj isEqualToString:type] || [NSLocalizedString(obj, nil) isEqualToString:type])
        {
            NSNumber *num = key;
            result = num.unsignedIntegerValue;
        }
    }];

    return result;
}

- (void)writeData:(NSData *)output
{
    NSAssert(NO, @"Subclasses must override this message");
}

@end