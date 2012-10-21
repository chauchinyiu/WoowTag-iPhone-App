//
//  ResultStoreTableListVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/10/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreResultTableViewCell.h"
#import "StoreInfoVC.h"
@interface ResultStoreTableListVC : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView	 	*_tableView;
    NSMutableArray *_stores;
    UIViewController   *_managingViewController;
}

@property (nonatomic, retain) UIViewController   * managingViewController;
@property (nonatomic, retain) IBOutlet UITableView  *tableView ;
@property (nonatomic, assign) IBOutlet  StoreResultTableViewCell *tableViewCell;
@property (nonatomic, retain) NSMutableArray  *stores;
@property (nonatomic, retain) IBOutlet UIView *noResultView;
- (id)initWithParentViewController:(UIViewController *)aViewController ;
@end
