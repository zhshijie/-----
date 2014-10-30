//
//  DLDataPicker.m
//  DLDataPicker
//
//  Created by Derick Liu: masterliuwei@gmail.com  on 10/9/13.
//  Copyright (c) 2013 Derick Liu: masterliuwei@gmail.com . All rights reserved.
//

#import "DLDataPicker.h"
#import <objc/runtime.h>

static const CGFloat kToolBarHeight = 44.0;

@interface DLDataPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) id<DLDataPickerDataSource> dataSource;
@property (assign, nonatomic) id<DLDataPickerDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *resultArray;

@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) UIToolbar *toolBar;
@end

@implementation DLDataPicker

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithDelegate:(id<DLDataPickerDelegate>)delegate dataSource:(id<DLDataPickerDataSource>)dataSource
{
    if (self = [super init]) {
        
        _delegate = delegate;
        _dataSource = dataSource;
        
        [self config];
    }
    
    return self;
}

- (id)initWithDelegate:(id<DLDataPickerDelegate>)delegate dataSource:(id<DLDataPickerDataSource>)dataSource originY:(CGFloat)originY
{
    DLDataPicker *dlDataPicker = [self initWithDelegate:delegate dataSource:dataSource];
    [dlDataPicker setOringinY:originY];
    return dlDataPicker;
}

- (void)config
{
    [self configDelegateMethods];
    [self configUI];
}

#pragma mark - Load Delegate Methods Danymicly
- (void)configDelegateMethods
{
    [self configDelegate:_delegate Method:@selector(pickerView:widthForComponent:) implementation:(IMP) pickerViewWidthForComponent responesDelegateMethod:@selector(dLDataPicker:widthForComponent:)];
    
    [self configDelegate:_delegate Method:@selector(pickerView:rowHeightForComponent:) implementation:(IMP)pickerViewRowHeightForComponent responesDelegateMethod:@selector(dLDataPicker:rowHeightForComponent:)];
    
    [self configDelegate:_delegate Method:@selector(pickerView:titleForRow:forComponent:) implementation:(IMP) pickerViewTitleForRowInComponent responesDelegateMethod:@selector(dLDataPicker:titleForRow:forComponent:)];
    
    [self configDelegate:_delegate Method:@selector(pickerView:attributedTitleForRow:forComponent:) implementation:(IMP) pickerViewAttributedTitleForRowforComponent responesDelegateMethod:@selector(dLDataPicker:attributedTitleForRow:forComponent:)];
    
    [self configDelegate:_delegate Method:@selector(pickerView:viewForRow:forComponent:reusingView:) implementation:(IMP) pickerViewTitleForRowInComponent responesDelegateMethod:@selector(dLDataPicker:viewForRow:forComponent:reusingView:)];
}


- (void)configDelegate:(id)delegate Method:(SEL)sel implementation:(IMP)imp responesDelegateMethod:(SEL)responseDelegateSel
{
    if ([self.delegate respondsToSelector:responseDelegateSel]) {
        [self configDelegate:_delegate Method:@selector(pickerView:titleForRow:forComponent:) implementation:(IMP)pickerViewTitleForRowInComponent];
    }
}

- (void)configDelegate:(id)delegate Method:(SEL)sel implementation:(IMP)imp
{
    NSMethodSignature *signature = [self methodSignatureForSelector:sel];

    NSMutableString *encodingString = nil;
    for (int i = 0; i < [signature numberOfArguments]; i++) {
        if (!encodingString) {
            encodingString = [[NSMutableString alloc] init];
        }
        [encodingString appendString:[NSString stringWithFormat:@"%s", [signature getArgumentTypeAtIndex:i]]];
    }
    class_addMethod([self class], sel, imp, [encodingString UTF8String]);
}

#pragma mark - UI
- (void)configUI
{
//    CGRect windowFrame = self.window.frame;
    _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,320, kToolBarHeight)];
//    _cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    _cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel:)];
//    _doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    _doneButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    _toolBar.items = @[_cancelButtonItem,flexibleSpace, _doneButtonItem];
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    self.frame = CGRectMake(0, 0, _pickerView.frame.size.width, _pickerView.frame.size.height + _toolBar.frame.size.height);
    
    _pickerView.center = CGPointMake(_pickerView.center.x, self.frame.size.height - _pickerView.frame.size.height / 2.0);
    
    [self addSubview:_toolBar];
    [self addSubview:_pickerView];
}

- (void)setOringinY:(CGFloat)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
}

- (void)setToolBarStyle:(UIBarStyle)barStyle
{
    _toolBar.barStyle = barStyle;
}

- (void)setToolBarBackgroundImage:(UIImage *)image
{
    [_toolBar setBackgroundImage:image forToolbarPosition:UIToolbarPositionTop barMetrics:UIBarMetricsDefault];
}

#pragma mark - action

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(self.frame.origin.x, [[UIScreen mainScreen] bounds].size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            UIView *superView = self.superview;
            [self removeFromSuperview];
            [superView removeFromSuperview];
        }
    }];
}

- (void)cancel:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dLDataPickerDidCancel:)]) {
        [self dismiss];
        [self.delegate dLDataPickerDidCancel:self];
    }
}

- (void)done:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(dLDataPicker:didFinishWithResult:)]) {
        for (int i = 0; i < [_pickerView numberOfComponents]; i++) {
            if (!_resultArray) {
                _resultArray = [[NSMutableArray alloc] init];
            }
            [_resultArray addObject:[self indexPathOfComponent:i]];
        }
        
        NSArray *resultArray = _resultArray;
        
        [self dismiss];
        [self.delegate dLDataPicker:self didFinishWithResult:resultArray];
    }
}

- (NSIndexPath *)indexPathOfComponent:(NSInteger)component
{
    return [NSIndexPath indexPathForRow:[_pickerView selectedRowInComponent:component] inComponent:component];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [_pickerView selectRow:row inComponent:component animated:animated];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    UIView *coverView = [[UIView alloc] initWithFrame:view.bounds];
    coverView.backgroundColor = [UIColor clearColor];
    
    CGFloat y = self.frame.origin.y;
    [self setOringinY:coverView.bounds.size.height];
    
    [view addSubview:coverView];
    [coverView addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        [self setOringinY:y];
    } completion:^(BOOL finished) {
        if (finished) {
            
        }
    }];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.dataSource numberOfComponentsInDLDataPicker:self];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.dataSource dLDataPicker:self numberOfRowsInComponent:component];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

CGFloat pickerViewWidthForComponent(id self, SEL _cmd, UIPickerView *pickerView, NSInteger component)
{
    DLDataPicker *dLDataPicker = (DLDataPicker *)self;
    return [dLDataPicker.delegate dLDataPicker:dLDataPicker widthForComponent:component];
}

CGFloat pickerViewRowHeightForComponent(id self, SEL _cmd, UIPickerView *pickerView, NSInteger component)
{
    DLDataPicker *dLDataPicker = (DLDataPicker *)self;
    return [dLDataPicker.delegate dLDataPicker:dLDataPicker rowHeightForComponent:component];
}

 NSString * pickerViewTitleForRowInComponent(id self, SEL _cmd, UIPickerView *pickerView, NSInteger row, NSInteger component)
{
    DLDataPicker *dLDataPicker = (DLDataPicker *)self;
    return [dLDataPicker.delegate dLDataPicker:dLDataPicker titleForRow:row forComponent:component];
}

NSAttributedString *pickerViewAttributedTitleForRowforComponent(id self, SEL _cmd, UIPickerView *pickerView, NSInteger row, NSInteger component)
{
    DLDataPicker *dLDataPicker = (DLDataPicker *)self;
    return [dLDataPicker.delegate dLDataPicker:dLDataPicker attributedTitleForRow:row forComponent:component];
}

UIView * pickerViewviewForRowforComponentreusingView(id self, SEL _cmd, UIPickerView *pickerView, NSInteger row, NSInteger component, UIView *view)
{
    DLDataPicker *dLDataPicker = (DLDataPicker *)self;
    return [dLDataPicker.delegate dLDataPicker:dLDataPicker viewForRow:row forComponent:component reusingView:view];
}

@end

@interface NSIndexPath ()
@property(readwrite, nonatomic) NSInteger component;
@property(readwrite, nonatomic) NSInteger rowIndex;
@end

@implementation NSIndexPath (UIPickerView)
static char componentKey;
static char rowKey;

- (NSInteger)component
{
    NSNumber *number = objc_getAssociatedObject(self, &componentKey);
    return number.intValue;
}

- (NSInteger)rowIndex
{
    NSNumber *number = objc_getAssociatedObject(self, &rowKey);
    return number.intValue;
}

- (void)setComponent:(NSInteger)component
{
    objc_setAssociatedObject(self, &componentKey, [NSNumber numberWithInt:component], OBJC_ASSOCIATION_COPY);
}

- (void)setRowIndex:(NSInteger)rowIndex
{
    objc_setAssociatedObject(self, &rowKey, [NSNumber numberWithInt:rowIndex], OBJC_ASSOCIATION_COPY);
}

+ (NSIndexPath *)indexPathForRow:(NSInteger)rowIndex inComponent:(NSInteger)component
{
    NSIndexPath *indexPath = [[NSIndexPath alloc] init];
    indexPath.component = component;
    indexPath.rowIndex = rowIndex;
    
    return indexPath;
}
@end
