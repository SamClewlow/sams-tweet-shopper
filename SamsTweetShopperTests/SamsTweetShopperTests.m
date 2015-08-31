//
//  SamsTweetShopperTests.m
//  SamsTweetShopperTests
//
//  Created by Sam Clewlow on 02/08/2015.
//  Copyright (c) 2015 SamClewlow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "STSSearchTermValidInteractor.h"

@interface SamsTweetShopperTests : XCTestCase

@end

@implementation SamsTweetShopperTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testValidString {
    
    STSSearchTermValidInteractor *interactor = [[STSSearchTermValidInteractor alloc] init];
    
    BOOL valid = [interactor isSearchTermValid:@"String!"];
    
    XCTAssertTrue(valid, @"String should be valid");
}



@end
