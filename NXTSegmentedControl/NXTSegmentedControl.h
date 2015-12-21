//
//  NXTSegmentedControl.h
//  
//
//  Created by Patrick Mick on 6/13/14.
//
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface NXTSegmentedControl : UIControl

/**
 *  The number of items that the segmented control is currently displaying
 */
@property (nonatomic, readonly) NSUInteger numberOfSegments;

/**
 *  The index of the currently selected segment. A newly created control will
 *  start with a selectedSegmentIndex of 0.
 */
@property (nonatomic, assign) NSInteger selectedSegmentIndex;

/**
 *  The white space between the edge of the control and the thumb. This value
 *  defaults to 3.0f revealing some color around the selection thumb.
 */
@property (nonatomic, assign) CGFloat thumbEdgeInset;

/**
 *  The color of the selection thumb. By default, the thumb is white.
 */
@property (nonatomic, strong) UIColor *thumbColor;

/**
 *  Initializes a segmented control with the provided items.
 *
 *  @param items NSString items that should be displayed in the segmented control
 *
 *  @return The newly-initialized segmented control.
 */
- (instancetype)initWithItems:(NSArray *)items;


/**
 *  Adds the ability to change the selected segment without animation. Changing
 *  the property would always animate.
 *  
 *  @param selectedSegmentIndex The selected index to change to
 *  @param animated Flag that specificies whether or not the movement of 
 *                  the thumb to the new index should be animated
 *
 */
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex animated:(BOOL)flag;

/**
 *  Replaces the text on a segment already in the segmented control.
 *
 *  @param title   A string to display in the segmented control
 *  @param segment An index number identifying a segment between 0 and 
 *                 numberOfSegments minus 1
 */
- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment;

/**
 *  Gets the title for a segment at a given index.
 *
 *  @param segment An index number identifying a segment between 0 and
 *                 numberOfSegments minus 1
 *
 *  @return Returns the string (title) assigned to the receiver as content.
 */
- (NSString *)titleForSegmentAtIndex:(NSUInteger)segment;

/**
 *  Returns the text attributes of the title for a given control state. Returns
 *  nil if no custom title text attributes were set.
 *
 *  @param state A control state.
 *
 *  @return The text attributes of the title for state.
 */
- (NSDictionary *)titleTextAttributesForState:(UIControlState)state;

/**
 *  Sets the text attributes of the title for a given control state. Currently
 *  supports:
 *  
 *      NSFontAttributeName
 *      
 *  Text color for text that is not selected will probably have its color 
 *  provided by thumbColor, but setting text color is currently not available
 *
 *  Selected text color is provided through tintColor.
 *
 *  @param attributes The text attributes of the title for state.
 *  @param state      A control state.
 */
- (void)setTitleTextAttributes:(NSDictionary *)attributes forState:(UIControlState)state;

@end
