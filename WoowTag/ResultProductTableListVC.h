//
//  ResultProductTableListVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//
#import "ProductResultTableViewCell.h"
#import <UIKit/UIKit.h>


@interface ResultProductTableListVC : UIViewController  <UITableViewDelegate, UITableViewDataSource>{
    UITableView	 	*_tableView;
    NSMutableArray *_products;
    NSString *_totalnums;
    UITableViewCell *_showMoreCell;
//    NSDictionary *_parameters;
    BOOL _loadNextPageFailed;
    BOOL _isLoading;
    int _pageNum;
    UIViewController   *_managingViewController;
}
@property (nonatomic, retain) UIViewController   * managingViewController;
@property (nonatomic, retain) IBOutlet UITableView  *tableView ;
@property (nonatomic, assign) IBOutlet  ProductResultTableViewCell *tableViewCell;
@property (nonatomic, retain) NSMutableArray  *products;
@property (nonatomic, retain) NSString *totalnums;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, strong) IBOutlet UITableViewCell *showMoreCell;
@property (nonatomic, retain) IBOutlet UIView *noResultView;
- (id)initWithParentViewController:(UIViewController *)aViewController ;
- (IBAction)onLoadNextPage:(id)sender;
@end
