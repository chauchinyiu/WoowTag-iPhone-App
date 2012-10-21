//
//  Product.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/4/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

 
 

// @class Store; 
 #import "Store.h"

@interface Product : NSObject{
 
}
@property (nonatomic, retain) NSString * productId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * stock;
@property (nonatomic, retain) NSNumber * rate;
@property (nonatomic, retain) Store * store;
@property (nonatomic, retain) NSArray * imagelinks;
@property (nonatomic, retain) NSArray * tags;

//+ (void)callListWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(NSArray *products))block ;

+ (void)callDetailWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(Product *product))block ;

+ (Product*) parseProductJson:(NSDictionary *)  attributes ;
@end
