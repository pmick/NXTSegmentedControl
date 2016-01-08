//
//  NXTSegmentedControl.m
//
//
//  Created by Patrick Mick on 6/13/14.
//
//

#import "NXTSegmentedControl.h"

#define DEFAULT_THUMB_COLOR [UIColor whiteColor]

static const NSInteger kNXTSegmentedControlDefaultHandleInset = 3;
static const CGFloat kNXTSegmentedControlDefaultWidth = 200.0f;
static const CGFloat kNXTSegmentedControlDefaultHeight = 33.0f;
static const NSTimeInterval kNXTSegmentedControlDefaultAnimationDuration = 0.10f;

@interface NXTSegmentedControl () {
    UIColor *_thumbColor;
}

@property (nonatomic, copy) NSMutableArray *segmentTitles;
@property (nonatomic, strong) UIView *thumb;
@property (nonatomic, strong) UIView *selectedLabelContainer;
@property (nonatomic, strong) UIView *labelContainer;
@property (nonatomic, copy) NSMutableArray *selectedLabels;
@property (nonatomic, copy) NSMutableArray *labels;
@property (nonatomic, strong) CALayer *maskLayer;
@property (nonatomic, strong) UIView *thumbShowLayer;
@property (nonatomic, copy) NSMutableDictionary *titleTextAttributes;

@end

@implementation NXTSegmentedControl

#pragma mark - Lifecycle

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _segmentTitles = [items mutableCopy];
    _titleTextAttributes = [NSMutableDictionary dictionary];

    [self _setup];
    [self _buildSegmentsArrayForItems:items];
    
    self.frame = CGRectMake(0, 0, kNXTSegmentedControlDefaultWidth, kNXTSegmentedControlDefaultHeight);
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self _layoutLabels];
    [self _layoutThumb];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self _drawBackgroundWithTintColor];
    
    // Fixes a bug that prevented labels from getting inherited tintColor from the window
    // because set tint color is not called.
    for (UILabel *label in self.selectedLabels) {
        label.textColor = self.tintColor;
    }
}

- (NSUInteger)numberOfSegments {
    return self.segmentTitles.count;
}

#pragma mark - Accessors

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    [self setSelectedSegmentIndex:selectedSegmentIndex animated:YES];
}

- (CGFloat)thumbEdgeInset {
    if (_thumbEdgeInset <= 0) {
        return kNXTSegmentedControlDefaultHandleInset;
    }
    
    return _thumbEdgeInset;
}

- (void)setThumbColor:(UIColor *)thumbColor {
    _thumbColor = thumbColor;
    self.thumb.backgroundColor = thumbColor;
}

- (UIColor *)thumbColor {
    if (_thumbColor) {
        return _thumbColor;
    }
    
    return DEFAULT_THUMB_COLOR;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    [self setNeedsDisplay];
}

#pragma mark - Public Methods

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)flag {
    _selectedSegmentIndex = selectedSegmentIndex;
    [self _moveThumbToSelectedSegment:selectedSegmentIndex animated:flag];
}

- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment {
    return self.segmentTitles[segment];
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
    self.segmentTitles[segment] = title;
    [self _updateLabelWithTitle:title atIndex:segment];
}

- (NSDictionary *)titleTextAttributesForState:(UIControlState)state {
    return self.titleTextAttributes[@(state)];
}

- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state {
    NSParameterAssert(attributes);
    
    self.titleTextAttributes[@(state)] = attributes;
    
    if (state == UIControlStateNormal) {
        [self _updateLabels:self.labels withAttributes:attributes];
        
        if (!self.titleTextAttributes[@(UIControlStateSelected)]) {
            [self _updateLabels:self.selectedLabels withAttributes:attributes];
        }
    } else if (state == UIControlStateSelected) {
        [self _updateLabels:self.selectedLabels withAttributes:attributes];
    }
}

#pragma mark - Touches

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super beginTrackingWithTouch:touch withEvent:event];
    
    CGPoint touchPoint = [touch locationInView:self];
    BOOL shouldBeginTouches = [self _isValidTouchPoint:touchPoint];
    
    return shouldBeginTouches;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super continueTrackingWithTouch:touch withEvent:event];
    
    CGFloat horizontalDifference = [touch locationInView:self].x - [touch previousLocationInView:self].x;
    CGRect newThumbFrame = self.thumb.frame;
    newThumbFrame.origin.x += horizontalDifference;
    
    if (![self _isNewThumbFrameValid:newThumbFrame]) {
        newThumbFrame = [self _validatedThumbFrame:newThumbFrame];
    }
    
    [self _moveThumbToNewFrame:newThumbFrame];
    
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    
    NSInteger nearestIndex = [self _nearestIndexForCurrentThumbPosition];
    
    if (nearestIndex != self.selectedSegmentIndex) {
        [self _updateSelectedIndexAndNotify:nearestIndex];
    } else {
        [self _moveThumbToSelectedSegment:self.selectedSegmentIndex animated:YES];
    }
}

#pragma mark - Private: Setup

- (void)_setup {
    self.backgroundColor = [UIColor clearColor];
    
    _selectedSegmentIndex = 0;
    
    _selectedLabels = [NSMutableArray array];
    _labels = [NSMutableArray array];
    
    [self _buildThumb];
    [self _buildLabelContainers];
    
    [self addSubview:self.thumb];
    [self addSubview:self.labelContainer];
    [self addSubview:self.selectedLabelContainer];
    
    [self _buildMaskLayer];
    [self _buildShowLayer];
    
    self.selectedLabelContainer.layer.mask = self.maskLayer;
    [self.maskLayer addSublayer:self.thumbShowLayer.layer];
}

- (void)_buildThumb {
    _thumb = [UIView new];
    _thumb.backgroundColor = self.thumbColor;
    _thumb.userInteractionEnabled = NO;
}

- (void)_buildLabelContainers {
    self.selectedLabelContainer = [UIView new];
    self.selectedLabelContainer.userInteractionEnabled = NO;
    
    self.labelContainer = [UIView new];
    self.labelContainer.userInteractionEnabled = NO;
}

- (void)_buildMaskLayer {
    self.maskLayer = [CALayer layer];
    self.maskLayer.backgroundColor = [[UIColor clearColor] CGColor];
}

- (void)_buildShowLayer {
    self.thumbShowLayer = [UIView new];
    self.thumbShowLayer.backgroundColor = [UIColor greenColor];
}

- (void)_layoutMasks {
    self.maskLayer.frame = self.selectedLabelContainer.bounds;
    self.thumbShowLayer.bounds = [self _thumbRect];
    self.thumbShowLayer.center = [self _centerForSegmentAtIndex:self.selectedSegmentIndex];
    self.thumbShowLayer.layer.cornerRadius = CGRectGetHeight([self _thumbRect]) / 2.0f;
}

- (void)_buildSegmentsArrayForItems:(NSArray *)items {
    for (NSInteger idx = 0; idx < items.count; idx++) {
        NSString *title = items[idx];
        if (![title isKindOfClass:[NSString class]]) {
            NSAssert(NO, @"Segmented control item must be a string! Item: %@", title);
        }
        
        [self _addLabelWithText:title atIndex:idx];
    }
}

#pragma mark - Private: Layout & Calculation

- (void)_layoutLabels {
    self.selectedLabelContainer.frame = self.bounds;
    self.labelContainer.frame = self.bounds;
    
    CGRect boundingRect = [self _thumbBoundingRect];
    CGFloat segmentWidth = CGRectGetWidth(boundingRect) / [self numberOfSegments];
    
    for (NSUInteger idx = 0; idx < self.selectedLabels.count; idx++) {
        UILabel *foregroundLabel = self.selectedLabels[idx];
        UILabel *backgroundLabel = self.labels[idx];
        
        CGRect desiredRect = [self _rectForLabelAtIndex:idx
                                       withSegmentWidth:segmentWidth
                                           boundingRect:boundingRect];
        foregroundLabel.frame = desiredRect;
        backgroundLabel.frame = desiredRect;
    }
    
    [self _layoutMasks];
}

- (void)_layoutThumb {
    _thumb.bounds = [self _thumbRect];
    _thumb.center = [self _centerForSegmentAtIndex:self.selectedSegmentIndex];
    _thumb.layer.cornerRadius = CGRectGetHeight([self _thumbRect]) / 2.0f;
}

- (CGRect)_rectForLabelAtIndex:(NSUInteger)index
              withSegmentWidth:(CGFloat)segmentWidth
                  boundingRect:(CGRect)boundingRect {
    CGFloat x = (segmentWidth * index) + self.thumbEdgeInset;
    CGFloat y = self.thumbEdgeInset;
    CGFloat width = segmentWidth;
    CGFloat height = CGRectGetHeight(boundingRect);
    return CGRectMake(x, y, width, height);
}

- (void)_drawBackgroundWithTintColor {
    UIBezierPath *backgroundPath = [UIBezierPath
                                    bezierPathWithRoundedRect:self.bounds
                                    cornerRadius:CGRectGetHeight(self.bounds) / 2.0f];
    [self.tintColor setFill];
    [backgroundPath fill];
}

- (BOOL)_isValidTouchPoint:(CGPoint)touchPoint {
    BOOL touchedSelectedSegment = CGRectContainsPoint([self _rectForSelectedSegment], touchPoint);
    BOOL touchedOtherSegment = NO;
    NSInteger selectedIndex = 0;
    for (NSInteger idx = 0; idx < self.segmentTitles.count; idx++) {
        if (CGRectContainsPoint([self _rectForSegmentAtIndex:idx], touchPoint) &&
            idx != self.selectedSegmentIndex) {
            touchedOtherSegment = YES;
            selectedIndex = idx;
            [self _updateSelectedIndexAndNotify:idx];
            break;
        }
    }
    
    BOOL shouldBeginTouches = NO;
    
    if (touchedSelectedSegment || touchedOtherSegment) {
        shouldBeginTouches = YES;
    }
    return shouldBeginTouches;
}

- (BOOL)_isNewThumbFrameValid:(CGRect)newThumbRect {
    return CGRectContainsRect([self _thumbBoundingRect], newThumbRect);
}

- (CGRect)_validatedThumbFrame:(CGRect)newThumbFrame {
    CGRect validatedThumbFrame = newThumbFrame;
    
    if (CGRectGetMaxX(newThumbFrame) > CGRectGetMaxX([self _thumbBoundingRect])) {
        CGFloat maxDifference = CGRectGetMaxX(newThumbFrame) - CGRectGetMaxX([self _thumbBoundingRect]);
        validatedThumbFrame.origin.x -= maxDifference;
    } else if (CGRectGetMinX(newThumbFrame) < CGRectGetMinX([self _thumbBoundingRect])) {
        CGFloat minDifference = CGRectGetMinX([self _thumbBoundingRect]) - CGRectGetMinX(newThumbFrame);
        validatedThumbFrame.origin.x += minDifference;
    }
    
    return validatedThumbFrame;
}

- (NSInteger)_nearestIndexForCurrentThumbPosition {
    NSInteger nearestIndex=0;
    CGFloat smallestDifference = CGFLOAT_MAX;
    
    for (NSInteger idx = 0; idx < self.segmentTitles.count; idx++) {
        CGRect segmentRect = [self _rectForSegmentAtIndex:idx];
        CGPoint segmentCenter =
        CGPointMake(CGRectGetMidX(segmentRect), CGRectGetMidY(segmentRect));
        
        CGFloat diffX = ABS(_thumb.center.x - segmentCenter.x);
        
        if (diffX < smallestDifference) {
            smallestDifference = diffX;
            nearestIndex = idx;
        }
    }
    return nearestIndex;
}

- (void)_updateSelectedIndexAndNotify:(NSInteger)newIndex {
    self.selectedSegmentIndex = newIndex;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)_moveThumbToNewFrame:(CGRect)newThumbFrame {
    self.thumb.frame = newThumbFrame;
    self.thumbShowLayer.frame = newThumbFrame;
}

- (void)_addLabelWithText:(NSString *)title atIndex:(NSUInteger)index {
    UILabel *foregroundLabel = [self _labelWithTitle:title textColor:self.tintColor];
    UILabel *backgroundLabel = [self _labelWithTitle:title textColor:[UIColor whiteColor]];
    
    [self.selectedLabels insertObject:foregroundLabel atIndex:index];
    [self.labels insertObject:backgroundLabel atIndex:index];
    
    [self.selectedLabelContainer addSubview:foregroundLabel];
    [self.labelContainer addSubview:backgroundLabel];
}

- (UILabel *)_labelWithTitle:(NSString *)title textColor:(UIColor *)textColor {
    UILabel *label = [UILabel new];
    label.textColor = textColor;
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:13];
    
    return label;
}

- (void)_updateLabelWithTitle:(NSString *)title atIndex:(NSUInteger)index {
    UILabel *foregroundLabel = self.selectedLabels[index];
    UILabel *backgroundLabel = self.labels[index];
    
    foregroundLabel.text = title;
    backgroundLabel.text = title;
}

- (CGRect)_thumbRect {
    CGRect boundingRect = [self _thumbBoundingRect];
    
    CGFloat width;
    if ([self numberOfSegments] > 0) {
        width = CGRectGetWidth(boundingRect) / [self numberOfSegments];
    } else {
        width = CGRectGetWidth(boundingRect);
    }
    
    CGFloat height = CGRectGetHeight(boundingRect);
    
    return CGRectMake(boundingRect.origin.x, boundingRect.origin.y, width,
                      height);
}

- (CGRect)_thumbBoundingRect {
    UIEdgeInsets insets =
    UIEdgeInsetsMake(self.thumbEdgeInset,
                     self.thumbEdgeInset,
                     self.thumbEdgeInset,
                     self.thumbEdgeInset);
    CGRect thumbBoundingRect = UIEdgeInsetsInsetRect(self.bounds, insets);
    
    return thumbBoundingRect;
}

- (void)_moveThumbToSelectedSegment:(NSInteger)index animated:(BOOL)animated {
    
    CGRect newSelectionRect = [self _rectForSegmentAtIndex:index];
    CGPoint newCenter = [self _centerForSegmentAtIndex:index];
    if (animated) {
        CABasicAnimation *thumbAnimation = [self _thumbUpdateAnimationWithFromCenter:self.thumb.center toCenter:newCenter];
        [self.thumb.layer addAnimation:thumbAnimation forKey:@"basic"];
        self.thumb.layer.position = newCenter;
        
        CABasicAnimation *maskAnimation = [self _thumbUpdateAnimationWithFromCenter:self.thumbShowLayer.center toCenter:newCenter];
        [self.thumbShowLayer.layer addAnimation:maskAnimation forKey:@"position"];
        self.thumbShowLayer.layer.position = newCenter;
    } else {
        [self _moveThumbToNewFrame:newSelectionRect];
    }
}

- (CABasicAnimation *)_thumbUpdateAnimationWithFromCenter:(CGPoint)fromCenter
                                                 toCenter:(CGPoint)toCenter {
    CABasicAnimation *thumbAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    thumbAnimation.fromValue = [NSValue valueWithCGPoint:fromCenter];
    thumbAnimation.toValue = [NSValue valueWithCGPoint:toCenter];
    thumbAnimation.duration = kNXTSegmentedControlDefaultAnimationDuration;
    thumbAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return thumbAnimation;
}

- (CGRect)_rectForSelectedSegment {
    return [self _rectForSegmentAtIndex:self.selectedSegmentIndex];
}

- (CGRect)_rectForSegmentAtIndex:(NSInteger)index {
    if (index < [self numberOfSegments]) {
        UILabel *segment = self.selectedLabels[index];
        return segment.frame;
    } else {
        return CGRectZero;
    }
}

- (CGPoint)_centerForSegmentAtIndex:(NSUInteger)index {
    if (index < [self numberOfSegments]) {
        UILabel *segment = self.selectedLabels[index];
        return segment.center;
    } else {
        return CGPointZero;
    }
}

- (void)_updateLabels:(NSArray *)labels withAttributes:(NSDictionary *)attributes {
    for (UILabel *label in labels) {
        if (attributes[NSFontAttributeName]) {
            label.font = attributes[NSFontAttributeName];
        }
        if (attributes[NSForegroundColorAttributeName]) {
            label.textColor = attributes[NSForegroundColorAttributeName];
        }
    }
}

@end
