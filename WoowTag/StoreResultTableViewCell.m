//
//  StoreResultTableViewCell.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/6/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import "StoreResultTableViewCell.h"
 
@implementation StoreResultTableViewCell

@synthesize store = _store;
@synthesize saveStore = _saveStore;
@synthesize title  = _title;
@synthesize tags = _tags;
@synthesize phone = _phone;
@synthesize address = _address;
@synthesize thumbnail = _thumbnail;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)setStore:(Store *)store {
    
    UIImageView  *thumbnail = (UIImageView *)[self viewWithTag:CELL_STORE_THUMBNAIL_IMAGE];
	UILabel *lblTitle = (UILabel *)[self viewWithTag:CELL_STORE_TITLE_LABEL];
	UILabel *lblTags = (UILabel *)[self viewWithTag:CELL_STORE_TAGS_LABEL];
	UILabel *lblAddress= (UILabel *)[self viewWithTag:CELL_STORE_ADDRESS_LABEL];
    UILabel *lblPhone = (UILabel *)[self viewWithTag:CELL_STORE_PHONE_LABEL];
    

    _store = store;
    lblTitle.text= _store.name;
    lblPhone.text = _store.phone;
    lblAddress.text = _store.address; //[NSString stringWithFormat:@"%@",_store.stock];
    lblTags.text = [WoowTagToolKit convertStringArrayToString:_store.tags] ; 
    
     NSURL *url = [NSURL URLWithString: _store.imageUrl];
    [thumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"store_preview"]];
    
    
}

- (void)setSaveStore:(SaveStore *)savestore{
    
    UIImageView  *thumbnail = (UIImageView *)[self viewWithTag:CELL_STORE_THUMBNAIL_IMAGE];
	UILabel *lblTitle = (UILabel *)[self viewWithTag:CELL_STORE_TITLE_LABEL];
	UILabel *lblTags = (UILabel *)[self viewWithTag:CELL_STORE_TAGS_LABEL];
	UILabel *lblAddress= (UILabel *)[self viewWithTag:CELL_STORE_ADDRESS_LABEL];
    UILabel *lblPhone = (UILabel *)[self viewWithTag:CELL_STORE_PHONE_LABEL];
    
    _saveStore = savestore;
    lblTitle.text= _saveStore.name;
    lblPhone.text = _saveStore.phone;
    lblAddress.text = _saveStore.address; //[NSString stringWithFormat:@"%@",_store.stock];
    lblTags.text = [WoowTagToolKit convertStringArrayToString:_saveStore.tags] ; 

    
    NSURL *url = [NSURL URLWithString: _saveStore.imageUrl];
    [thumbnail setImageWithURL:url placeholderImage:[UIImage imageNamed:@"store_preview"]];
    
    
}

@end
