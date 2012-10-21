//
//  FavoriteStoreListVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/6/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreResultTableViewCell.h"
#import "StoreInfoVC.h"
#import "WoowTagAppDelegate.h"

@interface FavoriteStoreListVC : UIViewController<UITableViewDataSource , UITableViewDelegate,NSFetchedResultsControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_storelist;
    BOOL isEditMode;
    NSIndexPath *  deleteIndexPath;
    NSManagedObjectContext *_managedObjectContext; 
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain)  NSArray *storelist;
@property (nonatomic, assign) IBOutlet StoreResultTableViewCell *tableViewCell;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIView *noResultView;
@end