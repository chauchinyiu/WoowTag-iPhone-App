//
//  Store.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/10/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "Product.h"

@interface Store : NSObject{
    
}
 

@property (nonatomic, retain) NSString * storeId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * store_url;
@property (nonatomic, retain) NSString * fax; 
@property (nonatomic, retain) NSString * description; 
@property (nonatomic, retain) NSArray * tags; 
@property (nonatomic, retain) NSString *imageUrl ; 
@property (nonatomic, retain) NSMutableArray * productList;

//+ (void)callListWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(NSArray *stores))block ;

+ (void)callStoreWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(Store *store))block ;
+(Store*) parseStoreJson:(NSDictionary *)  attributes ;
@end
