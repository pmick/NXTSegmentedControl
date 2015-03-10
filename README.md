# NXTSegmentedControl

![Pod Version](https://cocoapod-badges.herokuapp.com/v/NXTSegmentedControl/badge.png) ![Travis Status](https://travis-ci.org/YayNext/NXTSegmentedControl.svg?branch=master)

The styled swipeable segmented control used in Next

![NXTSegmentedControl](https://raw.githubusercontent.com/YayNext/NXTSegmentedControl/master/images/demo.gif)


## Installation


Either manually add the NXTSegmentedControl.h/m files to your project, or add the NXTSegmentedControl cocoapod by adding the following line to your podfile:


```
pod 'NXTSegmentedControl'
```

## Usage

Start by importing the header.

```objective-c
#import <NXTSegmentedControl/NXTSegmentedControl.h>
```

Create the segmented control, and customize the appearance.

```objective-c
NXTSegmentedControl *segmentedControl = [[NXTSegmentedControl alloc] initWithItems:@[@"Post", @"Comments"]];
segmentedControl.tintColor = [UIColor redColor];
[segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
[self.view addSubview: segmentedControl];
```

