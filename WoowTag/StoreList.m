//
//  StoreList.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/25/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import "StoreList.h"
#import "Store.h"
@implementation StoreList
@synthesize stores;
@synthesize totalnums;
@synthesize status;
+ (void)callListWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(StoreList *storelist))block { 
    [[WebServiceClient sharedClient] getPath:webservicename  parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         StoreList *resultlist = [[StoreList alloc] init];
         id STORES = [JSON valueForKeyPath:@"store_list"];
         NSLog(@"JSON: %@ ",  STORES ) ;
         resultlist.totalnums = [STORES valueForKeyPath:@"number_of_results"]; 
         resultlist.status = [STORES valueForKeyPath:@"status"];
         NSMutableArray *mutableStores = [NSMutableArray arrayWithCapacity:[STORES count]];
         NSLog(@"count stores::: %d",[STORES count]);
         if(STORES != nil && [STORES count]>0){
             for( NSDictionary *attributes in STORES){
                 
                 Store *store=[Store parseStoreJson:attributes];
                 [mutableStores addObject:store];
                 
             }
             resultlist.stores = mutableStores;
             if (block) {
                 block(resultlist);
             }else{
                 block(nil);
             }
         }
         else{
             block(nil);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error retrieving: %@ ", error  );
         [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
         
         if (block) {
             block(nil);
         }
     }];

}
@end
