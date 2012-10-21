//
//  DetailTableViewCell.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/30/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DetailTableViewCell.h"
@interface DetailTableViewCell()
-(void) resizeUILabel:(UILabel*) label withString:(NSString*) string ;
@end
@implementation DetailTableViewCell
//@synthesize label;
//@synthesize icon;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)setDetailInfo:(NSString *)imgname withLabel:(NSString *) labelTitle {
    
    UIImageView *icon = (UIImageView *)[self viewWithTag:CELL_DETAIL_INFO_ICON];
	UILabel *lbl  = (UILabel *)[self viewWithTag:CELL_DETAIL_INFO_LABEL];
    lbl.text= labelTitle;
    [self resizeUILabel:lbl withString:labelTitle];
    [icon setImage:[UIImage imageNamed:imgname]];
 
}

-(void) resizeUILabel:(UILabel*) label withString:(NSString*) string {
    CGRect currentFrame = label.frame;
    CGSize max = CGSizeMake(label.frame.size.width, 500);
    CGSize expected = [string sizeWithFont:label.font constrainedToSize:max lineBreakMode:label.lineBreakMode]; 
    currentFrame.size.height = expected.height;
    label.frame = currentFrame;
}
@end
