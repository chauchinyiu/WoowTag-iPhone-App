//
//  FavoriteProductListVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/18/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductResultTableViewCell.h"
#import "ProductDetailVC.h"
#import "WoowTagAppDelegate.h"

@interface FavoriteProductListVC : UIViewController<UITableViewDataSource , UITableViewDelegate,NSFetchedResultsControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSArray *_productlist;
    BOOL isEditMode;
    NSIndexPath *  deleteIndexPath;
    NSManagedObjectContext *_managedObjectContext; 
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain)  NSArray *productlist;
@property (nonatomic, assign) ProductResultTableViewCell *tableViewCell;
 @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet UIView *noResultView;
@end
