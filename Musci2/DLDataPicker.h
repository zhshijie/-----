//
//  DLDataPicker.h
//  DLDataPicker
//
//  Created by Derick Liu: masterliuwei@gmail.com  on 10/9/13.
//  Copyright (c) 2013 Derick Liu: masterliuwei@gmail.com . All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DLDataPickerDataSource;
@protocol DLDataPickerDelegate;

@interface DLDataPicker : UIView

@property (strong, nonatomic) UIBarButtonItem *cancelButtonItem;
@property (strong, nonatomic) UIBarButtonItem *doneButtonItem;

- (id)initWithDelegate:(id<DLDataPickerDelegate>)delegate dataSource:(id<DLDataPickerDataSource>)dataSource;
- (id)initWithDelegate:(id<DLDataPickerDelegate>)delegate dataSource:(id<DLDataPickerDataSource>)dataSource originY:(CGFloat)originY;

- (void)setOringinY:(CGFloat)originY;

- (void)setToolBarStyle:(UIBarStyle)barStyle;
- (void)setToolBarBackgroundImage:(UIImage *)image;

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;

- (void)showInView:(UIView *)view animated:(BOOL)animated;
@end

@protocol DLDataPickerDataSource <NSObject>

@required
- (NSInteger)numberOfComponentsInDLDataPicker:(DLDataPicker *)dLDataPicker;
- (NSInteger)dLDataPicker:(DLDataPicker *)dLDataPicker numberOfRowsInComponent:(NSInteger)component;

@end

@protocol DLDataPickerDelegate <NSObject>

@optional
- (CGFloat)dLDataPicker:(DLDataPicker *)dLDataPicker widthForComponent:(NSInteger)component;
- (CGFloat)dLDataPicker:(DLDataPicker *)dLDataPicker rowHeightForComponent:(NSInteger)component;

- (NSString *)dLDataPicker:(DLDataPicker *)dLDataPicker titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (NSAttributedString *)dLDataPicker:(DLDataPicker *)dLDataPicker attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0); // attributed title is favored if both methods are implemented
- (UIView *)dLDataPicker:(DLDataPicker *)dLDataPicker viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)dLDataPickerDidCancel:(DLDataPicker *)dLDataPicker;
- (void)dLDataPicker:(DLDataPicker *)dLDataPicker didFinishWithResult:(NSArray *)resultArray;

@end

@interface NSIndexPath (UIPickerView)

+ (NSIndexPath *)indexPathForRow:(NSInteger)rowIndex inComponent:(NSInteger)component;

@property(readonly, nonatomic) NSInteger component;
@property(readonly, nonatomic) NSInteger rowIndex;

@end