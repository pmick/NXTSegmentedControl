//
//  InteractionTests.m
//  NXTSegmentedControl
//
//  Created by Patrick Mick on 3/5/15.
//  Copyright (c) 2015 Patrick Mick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>
#import "NXTSegmentedControl.h"

@interface NXTSegmentedControlInteractionTests : KIFTestCase

@end

@implementation NXTSegmentedControlInteractionTests

- (void)beforeEach {
    [super beforeEach];
    
    [tester swipeViewWithAccessibilityLabel:@"Segmented Control" inDirection:KIFSwipeDirectionLeft];
}

- (void)testSwipingToChangeSelectedSegment {
    UIView *label = [tester waitForViewWithAccessibilityLabel:@"label"];
    NXTSegmentedControl *segmentedControl = (NXTSegmentedControl *)[tester waitForViewWithAccessibilityLabel:@"Segmented Control"];
    
    [tester expectView:label toContainText:@"0"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 0);
    
    [tester swipeViewWithAccessibilityLabel:@"Segmented Control" inDirection:KIFSwipeDirectionRight];
    
    [tester expectView:label toContainText:@"1"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 1);
}

- (void)testTappingToChangeSelectedSegment {
    UIView *label = [tester waitForViewWithAccessibilityLabel:@"label"];
    NXTSegmentedControl *segmentedControl = (NXTSegmentedControl *)[tester waitForViewWithAccessibilityLabel:@"Segmented Control"];
    
    [tester expectView:label toContainText:@"0"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 0);

    UIScreen *mainScreen = [UIScreen mainScreen];
    CGRect screenRect = mainScreen.bounds;
    
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(screenRect),
                                      CGRectGetMidY(screenRect));
    
    CGPoint pointOnSecondSegment = CGPointMake(centerPoint.x + 30, centerPoint.y);
    [tester tapScreenAtPoint:pointOnSecondSegment];
    
    [tester expectView:label toContainText:@"1"];
    XCTAssertEqual(segmentedControl.selectedSegmentIndex, 1);
}

@end
