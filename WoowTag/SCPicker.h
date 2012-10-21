//
//  SCPicker.h
//  FormTable
//
//  Created by Thomas Blätte on 01.09.10.
//  Copyright 2010 Autoscout24 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@class SCPicker;


@protocol SCPickerDelegate

@optional
- (void)picker:(SCPicker *)picker didChangeValue:(id)value;
- (void)picker:(SCPicker *)picker didSelectSegmentedControlIndex:(NSInteger)index;
- (void)pickerDidHitDone:(SCPicker *)picker;

@end


@interface SCPicker : NSObject
{
@private
	UIView *_pickerView;
	UIView *_backgroundView;
	
	UILabel *_titleLabel;
	UIColor *_toolbarTintColor;
	NSArray *_segmentedControlTitles;
	UISegmentedControl *_segmentedControl;
	NSInteger _selectedSegmentIndex;
	BOOL _showDoneButton;
	BOOL _modal;
	BOOL _animated;
	
	BOOL _recreatePickerView;
	
@protected	
	id _value;	
	NSObject<SCPickerDelegate> *_delegate;
}

@property (nonatomic, retain) id value;
@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, retain) NSObject<SCPickerDelegate> *delegate;
@property (nonatomic, readonly) BOOL isVisible;
@property (nonatomic, readonly) CGFloat frameHeight;

@property (nonatomic, assign) BOOL modal;
@property (nonatomic, assign) BOOL animated;
@property (nonatomic, assign) BOOL showDoneButton;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, retain) UIColor *toolbarTintColor;
@property (nonatomic, retain) NSArray *segmentedControlTitles; 

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)hide;
- (void)hideAnimated:(BOOL)animated;

@end
