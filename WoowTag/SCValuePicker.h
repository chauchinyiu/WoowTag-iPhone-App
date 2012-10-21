//
//  SCDatePicker.h
//  FormTable
//
//  Created by Thomas Blätte on 01.09.10.
//  Copyright 2010 Autoscout24 GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCPicker.h"

@interface SCValuePicker : SCPicker <UIPickerViewDataSource, UIPickerViewDelegate>
{
	UIPickerView *_valuePicker;
	
	NSArray *_values;
	NSArray *_titles;
	
	CGFloat _fontSize;
	UITextAlignment _textAlignment;
}

@property (nonatomic) UITextAlignment textAlignment;

- (id)initWithValues:(NSArray *)values titles:(NSArray *)titles;


@end
