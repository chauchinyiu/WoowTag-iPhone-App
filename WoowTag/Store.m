//
//  Store.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/10/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "Store.h"
//@interface Store()
//+(Store*) parseStoreJson:(NSDictionary *)  attributes ;
//@end
@implementation Store

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
@synthesize storeId;
@synthesize name;
@synthesize phone;
@synthesize longitude;
@synthesize latitude;
@synthesize address;
@synthesize store_url;
@synthesize fax; 
@synthesize description; 
@synthesize tags;
@synthesize imageUrl;
@synthesize productList;



+ (void)callStoreWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(Store *store))block {
    NSMutableURLRequest *request = [[WebServiceClient sharedClient]  requestWithMethod:@"GET" path:webservicename parameters:parameter];
    [request setTimeoutInterval:5];
    AFHTTPRequestOperation *operation = [[WebServiceClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id JSON){
        
        NSDictionary* storeDict = [JSON valueForKeyPath:@"store"];
        NSLog(@"JSON: %@ ",  storeDict ) ;
        
        Store *store=[Store parseStoreJson:storeDict];
        
        if (block) {
            block(store);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
    
    [[WebServiceClient sharedClient]  enqueueHTTPRequestOperation:operation];
}

+(Store*) parseStoreJson:(NSDictionary *)  attributes  {
 
    Store *tempstore=  [[Store alloc] init];
    tempstore.storeId = [attributes valueForKeyPath:@"id"];
    tempstore.name = [attributes valueForKeyPath:@"name"];
    tempstore.address = [attributes valueForKeyPath:@"address"];
    tempstore.phone = [attributes valueForKeyPath:@"phone"];
    tempstore.fax = [attributes valueForKeyPath:@"fax"];
    tempstore.description = [attributes valueForKeyPath:@"description"];
    tempstore.store_url = [attributes valueForKeyPath:@"store_url"];
    tempstore.latitude = [attributes valueForKeyPath:@"latitude"];
    tempstore.longitude = [attributes valueForKeyPath:@"longitude"];
    tempstore.tags = [attributes valueForKeyPath:@"tags"];
   
    NSDictionary *imagesDict =  [attributes valueForKeyPath:@"images"] ;
    if([imagesDict count]){
        
        for(NSDictionary *imageattr in imagesDict){
            tempstore.imageUrl  = [imageattr valueForKeyPath:@"file_name"];
            break;
        }
    }
    tempstore.productList = [[NSMutableArray alloc] init];
    NSDictionary *productlist =  [attributes valueForKeyPath:@"product_list"] ;
    if ([productlist count]) {
        for(NSDictionary *product_dict in productlist){
            Product* prod=[Product parseProductJson:product_dict];
            [tempstore.productList addObject:prod];
        }
    }
    
    return tempstore;
}

@end
