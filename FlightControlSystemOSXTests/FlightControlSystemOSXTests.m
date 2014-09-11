//
//  FlightControlSystemOSXTests.m
//  FlightControlSystemOSXTests
//
//  Created by Craig Hughes on 8/15/14.
//  Copyright (c) 2014 Craig Hughes. All rights reserved.
//

@import Cocoa;
@import XCTest;
@import MapKit;

#import "FCSGoogleElevation.h"

@interface FlightControlSystemOSXTests : XCTestCase

@end

@implementation FlightControlSystemOSXTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPolyLineEncoding
{
    CLLocationCoordinate2D test1 = { 38.5, -120.2 };
    NSString *test1StringShouldBe = @"_p~iF~ps|U";
    XCTAssertEqualObjects(test1StringShouldBe, [FCSGoogleElevation encodeLocation:test1], @"Location encode failed");

    CLLocationCoordinate2D test2 = { 40.7, -120.95 };
    NSString *test2StringShouldBe = @"_ulLnnqC";
    CLLocationCoordinate2D test3 = { 43.252, -126.453 };
    NSString *test3StringShouldBe = @"_mqNvxq`@";

    NSArray *testLocations = @[
                               [NSValue valueWithMKCoordinate:test1],
                               [NSValue valueWithMKCoordinate:test2],
                               [NSValue valueWithMKCoordinate:test3],
                               ];
    NSString *longString = [NSString stringWithFormat:@"%@%@%@", test1StringShouldBe, test2StringShouldBe, test3StringShouldBe];

    XCTAssertEqualObjects(longString, [FCSGoogleElevation encodeLocations:testLocations], @"Location encode failed");
}

- (void)testAltitudeAtLocation
{
    XCTestExpectation *altitudeReturnedExpectation = [self expectationWithDescription:@"Altitude returned"];

    CLLocationCoordinate2D test1 = { 38.5, -120.2 };
    CLLocationDistance alt1 = 1204.842163085938;

    [FCSGoogleElevation altitudeAtLocation:test1 callback:^(CLLocationDistance altitude)
     {
         XCTAssertEqualWithAccuracy(altitude, alt1, 5.0, @"Altitude lookup differs significantly from expected value");
         [altitudeReturnedExpectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:16.0 handler:^(NSError *error){}];
}

- (void)testAltitudesAtLocations
{
    XCTestExpectation *altitudesReturnedExpectation = [self expectationWithDescription:@"Altitudes returned"];

    CLLocationCoordinate2D test1 = { 38.5, -120.2 };
    CLLocationDistance alt1 = 1204.842163085938;
    CLLocationCoordinate2D test2 = { 40.7, -120.95 };
    CLLocationDistance alt2 = 1691.3759765625;
    CLLocationCoordinate2D test3 = { 43.252, -126.453 };
    CLLocationDistance alt3 = -2984.89794921875;

    [FCSGoogleElevation altitudesAtLocations:@[
                                               [NSValue valueWithMKCoordinate:test1],
                                               [NSValue valueWithMKCoordinate:test2],
                                               [NSValue valueWithMKCoordinate:test3],
                                               ]
                                    callback:^(NSArray *altitudes)
     {
         XCTAssertEqual(altitudes.count, 3UL, @"Did not receive same number of altitudes as we asked for");
         XCTAssertEqualWithAccuracy([[altitudes objectAtIndex:0] doubleValue], alt1, 5.0, @"Altitude lookup differs significantly from expected value");
         XCTAssertEqualWithAccuracy([[altitudes objectAtIndex:1] doubleValue], alt2, 5.0, @"Altitude lookup differs significantly from expected value");
         XCTAssertEqualWithAccuracy([[altitudes objectAtIndex:2] doubleValue], alt3, 5.0, @"Altitude lookup differs significantly from expected value");
         [altitudesReturnedExpectation fulfill];
     }];

    [self waitForExpectationsWithTimeout:16.0 handler:^(NSError *error){}];
}

@end
