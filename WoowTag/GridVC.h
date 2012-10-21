//
//  GridVC.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/7/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailScrollView.h"
@interface GridVC : UIViewController <ImageScrollViewDelegate>{
    ThumbnailScrollView *_lastSearchScrollView;
    NSArray *_lastSearchProducts;
        UIImageView *_bookmarkImageView;
}
@property (nonatomic, retain)  UIImageView *bookmarkImageView;
@property (nonatomic,retain) IBOutlet ThumbnailScrollView *lastSearchScrollView;
@property (nonatomic,retain) NSArray *lastSearchProducts;
@property (nonatomic,retain) IBOutlet UIButton *searchBtn;
@property (nonatomic,retain) IBOutlet UIButton *favProductBtn;
@property (nonatomic,retain) IBOutlet UIButton *favStoreBtn;
@property (nonatomic,retain) IBOutlet  UIButton *infoBtn;
@property (nonatomic,retain) IBOutlet UILabel *slogan;
@property (nonatomic, retain) IBOutlet UILabel *searchLbl;
@property (nonatomic, retain) IBOutlet UILabel *favProductsLbl;
@property (nonatomic, retain) IBOutlet UILabel *favStoresLbl;
@property (nonatomic, retain) IBOutlet UILabel *infoLbl;
-(IBAction)btnPressGridButton:(id)sender;
-(void) setupLastSearchScrollView;
@end


