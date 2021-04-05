//
//  poker_oddsTests.m
//  poker-oddsTests
//
//  Created by Anthony Bajoua on 4/4/21.
//  Copyright © 2021 Anthony Bajoua. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Table.h"

@interface poker_oddsTests : XCTestCase

@end

@implementation poker_oddsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDeckProperties {
    Table *table = [[Table alloc] initWithPlayers:2];
    for (int i = 0; i < 1000000; i++) {
        [table playGame];
    }
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
