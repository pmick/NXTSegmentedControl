//
//  NXTSegmentedControlSnapshotTests.m
//  NXTSegmentedControl
//
//  Created by Patrick Mick on 3/5/15.
//  Copyright (c) 2015 Patrick Mick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>
#import "NXTSegmentedControl.h"

@interface NXTSegmentedControlSnapshotTests : FBSnapshotTestCase

@end

@implementation NXTSegmentedControlSnapshotTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.recordMode = NO;
}

- (void)testSegmentedControl_CreatedWithoutAFrame_ShouldProvideADefaultFrame {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"thing1", @"thing2"]];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should provide a default frame");
}

- (void)testSegementedControl_CreatedWithCustomFrame_ShouldRelayoutSubviews {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    segmentedControl.frame = CGRectMake(0, 0, 100, 50);
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should re-layout with a new frame");
}

- (void)testSegmentedControl_ChangingTintColor_ShouldUpdateTheTrackColor {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    segmentedControl.tintColor = [UIColor redColor];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should tint the background when tint color is changed.");
}

- (void)testSegmentedControl_WithLongText_ShouldClipTheText {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"testtesttesttesttesttest", @"test"]];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should tint the background when tint color is changed.");
}

- (void)testSegmentedControl_WithMoreThan2Segments_ShouldLayoutMultipleSegments {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test", @"test"]];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should display more than 2 segments correctly.");
}

- (void)testSegmentedControl_WithATonOfSegments_ShouldKeepTheLayoutLookingReasonable {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test", @"test", @"test", @"test", @"test", @"test", @"test"]];
    FBSnapshotVerifyLayer(segmentedControl.layer,  @"should display a ton of segments reasonably.");
}

- (void)testSegmentedControl_WithSmallerThanNormalEdgeInsets_ShouldHaveASmallBorder {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    segmentedControl.thumbEdgeInset = 1.0f;
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should have a 1 pixel border around the thumb.");
}

- (void)testSegmentedControl_WithColoredThumb_ShouldSetTheThumbsBackgroundColor {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    segmentedControl.thumbColor = [UIColor orangeColor];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should have an orange thumb");
}

- (void)testSegmentedControl_ChangingTitle_ShouldUpdateLabels {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    [segmentedControl setTitle:@"updated title" forSegmentAtIndex:0];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should update label text");
}

- (void)testSegmentedControl_ChangingTitleTextAttributes_ShouldUpdateLabels_IncludingSelectedIfNotProvided {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} forState:UIControlStateNormal];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should show bigger text");
}

- (void)testSegmentedControl_ChangingSelectedTitleTextAttributes_ShouldUpdateSelectedLabels {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} forState:UIControlStateSelected];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should show bigger text on selected label");
}

- (void)testSegmentedControl_ChangingTitleTextAttributes_AfterChangingSelectedTitleTextAttributes_ShouldKeepOriginalSelectedAttributes {
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]} forState:UIControlStateSelected];
    [segmentedControl setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:8]} forState:UIControlStateNormal];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should still bigger text under selection thumb");
}

- (void)testInheritingGlobalTintColor {
    UIWindow *window = [UIWindow new];
    window.tintColor = [UIColor purpleColor];
    
    NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"test", @"test"]];
    [window addSubview:segmentedControl];
    FBSnapshotVerifyLayer(segmentedControl.layer, @"should be tinted correctly");
}


@end
