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

/*
    CLLocationCoordinate2D test2 = { 40.7, -120.95 };
    NSString *test2StringShouldBe = @"_ulLnnqC";
    XCTAssertEqualObjects(test2StringShouldBe, [FCSGoogleElevation encodeLocation:test2], @"Location encode failed");

    CLLocationCoordinate2D test3 = { 43.252, -126.453 };
    NSString *test3StringShouldBe = @"_mqNvxq`@";
    XCTAssertEqualObjects(test3StringShouldBe, [FCSGoogleElevation encodeLocation:test3], @"Location encode failed");
*/
}

@end
