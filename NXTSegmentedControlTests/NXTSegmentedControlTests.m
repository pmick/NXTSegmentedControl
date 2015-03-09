//
//  NXTSegmentedControlTests.m
//  NXTSegmentedControlTests
//
//  Created by Patrick Mick on 3/5/15.
//  Copyright (c) 2015 Patrick Mick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NXTSegmentedControl.h"

@interface NXTSegmentedControlTests : XCTestCase

@end

@implementation NXTSegmentedControlTests

- (void)testGettingTheFirstTitle {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"thing1", @"thing2"]];
    NSString *title = [segmentedControl titleForSegmentAtIndex:0];
    XCTAssert([title isEqualToString:@"thing1"]);
}

- (void)testGettingTheSecondTitle {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"thing1", @"thing2"]];
    NSString *title = [segmentedControl titleForSegmentAtIndex:1];
    XCTAssert([title isEqualToString:@"thing2"]);
}

- (void)testChangingATitle {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"thing1", @"thing2"]];
    [segmentedControl setTitle:@"changedTitle" forSegmentAtIndex:0];
    NSString *title = [segmentedControl titleForSegmentAtIndex:0];
    XCTAssert([title isEqualToString:@"changedTitle"]);
}

- (void)testTitleTextAttributes {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"thing1", @"thing2"]];
    XCTAssertNil([segmentedControl titleTextAttributesForState:UIControlStateNormal]);
    
    NSDictionary *someAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:12]};
    [segmentedControl setTitleTextAttributes:someAttributes forState:UIControlStateNormal];
    XCTAssertEqual(someAttributes, [segmentedControl titleTextAttributesForState:UIControlStateNormal]);
    
    NSDictionary *selectedAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                         NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                         };
    [segmentedControl setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    XCTAssertEqual(selectedAttributes, [segmentedControl titleTextAttributesForState:UIControlStateSelected]);
}

@end
