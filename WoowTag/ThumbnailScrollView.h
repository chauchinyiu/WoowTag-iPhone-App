//
//  ThumbnailScrollView.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/20/12.
//  Copyright 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WoowTagContstant.h"
#import "Product.h"

@protocol ImageScrollViewDelegate <NSObject>

-(void)imageClickedAtView:(id)sender;
-(void)imageSelectedAtView:(id)sender;
@end

@interface ThumbnailScrollView : UIView{
    UIScrollView *_thumbnailScrollView;
    UIImageView *_bookmarkImageView;
    NSArray *_products;
    NSMutableArray *_images;
   id<ImageScrollViewDelegate> _delegate;
}
@property (nonatomic, retain)  UIScrollView *thumbnailScrollView; 
 @property (nonatomic, retain)  UIImageView *bookmarkImageView;
@property (nonatomic, retain)  NSArray *products;
@property (nonatomic, retain)  NSMutableArray *images;
@property (nonatomic, retain)  UILabel *titlelabel;
@property(nonatomic, retain) id<ImageScrollViewDelegate> delegate;
- (id)init;
-(void) setProductsImage:(NSArray *) items;
 
@end
