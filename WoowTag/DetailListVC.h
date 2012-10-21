//
//  DetailVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/16/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
#import "WoowTagContstant.h"
#import <QuartzCore/QuartzCore.h>
#import "MWPhotoBrowser.h"
#import "ProductDetailVC.h"
#import "DetailTableViewCell.h"
#import "StoreInfoVC.h"

@interface DetailListVC : UIViewController <UIScrollViewDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>{
    Product *_product;
    NSArray *_imagelinks;
    NSMutableArray *_bigImageLinks;
    UIScrollView *_mainScrollView;
    UIScrollView *_previewScrollView;
    UILabel *_productTitle;
    UILabel *_price;
 
    UIViewController * _managingViewController;
    UITableView *_tableView;
 
}
@property (nonatomic, retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, retain) IBOutlet UIScrollView *previewScrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet  UILabel *productTitle;

@property (nonatomic, retain) IBOutlet  UILabel *price;
//@property (nonatomic, retain) IBOutlet  UILabel *inStock;
//@property (nonatomic, retain) IBOutlet  UILabel *storename;
//@property (nonatomic, retain) IBOutlet  UILabel *address;
//@property (nonatomic, retain) IBOutlet  UILabel *productDescription;
@property(nonatomic, retain)  NSMutableArray *bigImageLinks;
@property (nonatomic, retain) Product  *product ;
@property(nonatomic, assign) int  selectedImageIndex;
@property (nonatomic, retain) IBOutlet  UITableView *tableView;
@property (nonatomic, assign)  DetailTableViewCell* tableViewCell;
@property (nonatomic, retain) UIViewController     * managingViewController;
- (id)initWithParentViewController:(UIViewController *)aViewController;
@end
