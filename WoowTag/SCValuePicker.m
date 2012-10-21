//
//  SCDatePicker.m
//  FormTable
//
//  Created by Thomas Blätte on 01.09.10.
//  Copyright 2010 Autoscout24 GmbH. All rights reserved.
//

#import "SCValuePicker.h"

// this private UILabel-subclass is used as labels for the rows in the UIPickerview
// In contrary to a standard UILabel, this label does not highlight in blue when pressed.

@interface SCPickerViewLabel : UILabel
{
}

@end

@implementation SCPickerViewLabel

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
	
	if( [self.superview respondsToSelector:@selector(setShowSelection:)] )
		[self.superview performSelector:@selector(setShowSelection:) ];
}


@end


// ---------------------------------------------------------------

@implementation SCValuePicker

@synthesize textAlignment=_textAlignment;

- (id)initWithValues:(NSArray *)values titles:(NSArray *)titles
{
	if( self = [super init] )
	{
		_values = values  ;
		_titles = titles  ;
		_textAlignment = UITextAlignmentLeft;
	}
	return self;
}

- (UIView *)createPickerView
{
	_valuePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
	_valuePicker.delegate = self;
	_valuePicker.dataSource = self;
	_valuePicker.showsSelectionIndicator = YES;
	
	[_valuePicker selectRow:[_values indexOfObject:_value] inComponent:0 animated:NO];
	
	return _valuePicker;
}

- (void)setValue:(id)value
{
	 
	
	_value =  value  ;
	
	NSUInteger index = [_values indexOfObject:_value];
	[_valuePicker selectRow:index inComponent:0 animated:YES];
}

 

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	self.value = [_values objectAtIndex:row];
	
	if( _delegate && [_delegate respondsToSelector:@selector(picker:didChangeValue:)] )
		[_delegate performSelector:@selector(picker:didChangeValue:) withObject:self withObject:self.value];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [_titles objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	CGSize rowSize = [pickerView rowSizeForComponent:component];
	
	if( !_fontSize )
	{
		_fontSize = 20.0f;
		for( NSString *title in _titles )
		{
			CGFloat adjustedFontSize = _fontSize;
			
			[title sizeWithFont:[UIFont boldSystemFontOfSize:20] minFontSize:13 actualFontSize:&adjustedFontSize forWidth:rowSize.width-18 lineBreakMode:UILineBreakModeTailTruncation];
			
			if( adjustedFontSize < _fontSize )
				_fontSize = adjustedFontSize;
		}
	}
	
	SCPickerViewLabel *rowView = (SCPickerViewLabel *)view;
	
	if( !rowView )
	{
		rowView =  [[SCPickerViewLabel alloc] initWithFrame:CGRectMake(0, 0, rowSize.width-18, rowSize.height)]  ;
		rowView.textColor = [UIColor blackColor];
		rowView.backgroundColor = [UIColor clearColor];
		rowView.shadowColor = [UIColor whiteColor];
		rowView.shadowOffset = CGSizeMake(0, 1);
		rowView.adjustsFontSizeToFitWidth = NO;
	}
	
	rowView.textAlignment = _textAlignment;
	rowView.font = [UIFont boldSystemFontOfSize:_fontSize];
	rowView.text = [_titles objectAtIndex:row];
	
	return rowView;
}


#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return [_titles count];
}

@end
