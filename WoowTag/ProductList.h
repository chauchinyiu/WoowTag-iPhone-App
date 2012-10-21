//
//  ProductList.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/21/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
@interface ProductList : NSObject
@property (nonatomic, retain) NSString * totalnums;
@property (nonatomic, retain) NSMutableArray * products;
@property (nonatomic, retain) NSString * status;


+ (void)callListWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(ProductList *productlist))block ;


@end
