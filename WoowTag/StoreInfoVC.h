//
//  StoreVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/1/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Store.h"
#import "DetailTableViewCell.h"
#import "SaveStore.h"
#import "NSManagedObject+Management.h"
#import "MBProgressHUD.h"

@interface StoreInfoVC : UIViewController<UIApplicationDelegate , UINavigationControllerDelegate,UITableViewDataSource, UITableViewDelegate,MBProgressHUDDelegate>{
    Store *_store;
    UIImageView *_storeImage;
    UILabel *_storeName;
    UITableView *_tableView;
    DetailTableViewCell *_tableViewCell;
    NSManagedObjectContext *_managedObjectContext; 
}
@property (nonatomic , retain) Store* store;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext; 
@property (nonatomic, retain) IBOutlet UIImageView *storeImage;
@property (nonatomic,retain) IBOutlet UILabel *storeName;
@property (nonatomic,retain) IBOutlet UILabel *storeDescription; 
@property (strong , nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) IBOutlet UIButton *productListBtn;
@property (strong, nonatomic)  DetailTableViewCell *tableViewCell;
- (IBAction)showProductList:(id)sender;
-(void)getStoreFromWebService:(NSString *) storeid;
@end
