//
//  FCSGoogleElevation.m
//  FlightControlSystemOSX
//
//  Created by Craig Hughes on 9/8/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

#import "FCSGoogleElevation.h"

@interface FCSGoogleElevation () <NSURLConnectionDelegate>
@end

// TODO: This is hardcoded for now to be my key; should us somthign larger scale; perhaps user's own Google ID.
static NSString * const FCSGoogleElevationAPIKey = @"AIzaSyCQCEazXsQqSA1ZmZzfs7vRNflcSQijdvM";


@implementation FCSGoogleElevation

// Use this as, eg, https://maps.googleapis.com/maps/api/elevation/json?key=AIzaSyCQCEazXsQqSA1ZmZzfs7vRNflcSQijdvM&locations=36.697029,-121.319237
// API docs for this Google API are here:
// https://developers.google.com/maps/documentation/elevation/

// Encode location using PolyLine algorithm
// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
+ (NSString *)encodeOneDimension:(CLLocationDegrees)dim
{
    // Multiple abs value by 1e5 and round
    uint32_t intDim = (uint32_t)lrint(fabs(dim * 100000));  // Coordinate * 1e5

    // If value negative, calculate 2s complement
    if(dim < 0)
    {
        intDim = ~intDim + 1;
    }

    // Left shift one bit
    intDim <<= 1;

    // If original decimal is negative, invert
    if(dim < 0)
    {
        intDim = ~intDim;
    }

    // Might be up to 6 bytes out
    NSMutableString *bytes = [NSMutableString stringWithCapacity:6];

    do
    {
        char fiveBits = intDim & 0x1f;   // Extract 5 bits

        intDim >>= 5;                    // Shift down
        if(intDim > 0)                   // If there's something left, then OR with 0x20
        {
            fiveBits |= 0x20;
        }

        // Add 63
        fiveBits += 63;

        // Append to the data stream
        [bytes appendString:[NSString stringWithFormat:@"%c", fiveBits]];
    } while(intDim > 0);

    return bytes;
}

+ (NSString *)encodeLocation:(CLLocationCoordinate2D)location
{
    return [NSString stringWithFormat:@"%@%@",
            [self encodeOneDimension:location.latitude],
            [self encodeOneDimension:location.longitude]];
}

+ (void) altitudeAtLocation:(CLLocationCoordinate2D)location callback:(void (^)(CLLocationDistance altitude))handler
{
    NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/elevation/json?key=%@&locations=enc:%@",
                         FCSGoogleElevationAPIKey,
                         [FCSGoogleElevation encodeLocation:location]]];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:theURL
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:15];

    __block BOOL gotResult = NO;
    [NSURLConnection sendAsynchronousRequest:theRequest
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               // TODO: better error handling
                               if(connectionError == nil)
                               {
                                   NSError *err;
                                   NSDictionary *resultObject = [NSJSONSerialization JSONObjectWithData:data
                                                                                     options:0
                                                                                       error:&err];
                                   NSLog(@"Got google elevation result: %@", resultObject);
                                   NSString *status = [resultObject objectForKey:@"status"];
                                   if([status isEqualToString:@"OK"])
                                   {
                                       NSArray *results = [resultObject objectForKey:@"results"];
                                       NSDictionary *firstResult = results.firstObject;
                                       NSNumber *elevation = [firstResult objectForKey:@"elevation"];
                                       gotResult = YES;
                                       handler(elevation.doubleValue);
                                   }
                                   else
                                   {
                                       NSLog(@"Google elevation lookup failed: %@", resultObject);
                                   }
                               }
                           }];
    if(!gotResult)
    {
        handler(0.0);
    }
}

+ (void) altitudeAtLocations:(NSArray *)locations callback:(void (^)(NSArray * altitudes))handler
{
    handler(@[]);
}


@end
