//
//  ProductListVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/26/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoowTagAppDelegate.h"
#import "ProductResultTableViewCell.h"
@interface ProductListVC : UIViewController<UITableViewDataSource , UITableViewDelegate,  UIAlertViewDelegate> {
    UITableView *_tableView;
    NSArray *_productlist;
    NSString *_storeName;
}
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain)  NSArray *productlist;
 @property (nonatomic, retain)  NSString *storeName;
@property (nonatomic, assign) ProductResultTableViewCell *tableViewCell;
@end
