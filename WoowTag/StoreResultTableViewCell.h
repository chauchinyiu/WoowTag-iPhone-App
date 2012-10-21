//
//  StoreResultTableViewCell.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/6/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "SaveStore.h"
#import "WoowTagContstant.h"
#import "UIImageView+AFNetworking.h"

@interface StoreResultTableViewCell : UITableViewCell
@property (nonatomic, retain) Store *store;
@property (nonatomic, retain) SaveStore *saveStore;
@property (retain , nonatomic)  UILabel *title;
@property (retain , nonatomic)  UILabel *phone;
@property (retain , nonatomic)  UILabel *tags;
@property (retain , nonatomic)  UILabel *address;
@property (retain, nonatomic)   UIImageView *thumbnail;
 
@end
