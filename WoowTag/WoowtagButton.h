//
//  WoowtagButton.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/24/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Product.h"
@interface WoowtagButton : UIButton{
    
}
@property (nonatomic,retain) Product *carriedProduct;

+ (id)createButtonWithType:(UIButtonType)buttonType;
@end
