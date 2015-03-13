//
//  ViewController.m
//  NXTSegmentedControl
//
//  Created by Patrick Mick on 3/5/15.
//  Copyright (c) 2015 Patrick Mick. All rights reserved.
//

#import "ViewController.h"
#import "NXTSegmentedControl.h"

@interface ViewController () {
    NXTSegmentedControl *_segmentedControl;
    UILabel *_selectedIndexLabel;
}

@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"thing1", @"thing2"]];
    _segmentedControl.accessibilityLabel = @"Segmented Control";
    [_segmentedControl addTarget:self
                          action:@selector(segmentedControlValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
    
    _selectedIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _selectedIndexLabel.textAlignment = NSTextAlignmentCenter;
    _selectedIndexLabel.text = @"0";
    _selectedIndexLabel.accessibilityLabel = @"label";
    [self.view addSubview:_selectedIndexLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect bounds = self.view.bounds;
    CGPoint screenCenter = CGPointMake(CGRectGetMidX(bounds),
                                       CGRectGetMidY(bounds));
    _segmentedControl.center = screenCenter;
    _selectedIndexLabel.center = CGPointMake(screenCenter.x, screenCenter.y + 50);
}

#pragma mark - Actions

- (void)segmentedControlValueChanged:(id)sender {
    NXTSegmentedControl *segmentedControl = (NXTSegmentedControl *)sender;
    NSString *t = [NSString stringWithFormat:@"%ld", (long)segmentedControl.selectedSegmentIndex];
    NSLog(t);
}

@end
