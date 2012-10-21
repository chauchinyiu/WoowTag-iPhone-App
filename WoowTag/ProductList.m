//
//  ProductList.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/21/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import "ProductList.h"

@implementation ProductList
@synthesize products;
@synthesize totalnums;
@synthesize status;

+ (void)callListWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(ProductList *productlist))block { 
    
    [[WebServiceClient sharedClient] getPath:webservicename  parameters:parameter success:^(AFHTTPRequestOperation *operation, id JSON)
     {
         ProductList *resultlist = [[ProductList alloc] init];
         id PRODUCTS = [JSON valueForKeyPath:@"product_list"];
         resultlist.totalnums = [JSON valueForKeyPath:@"number_of_results"]; 
         resultlist.status = [JSON valueForKeyPath:@"status"];
         NSLog(@"JSON: %@ ",  PRODUCTS ) ;
         NSMutableArray *mutableProducts = [NSMutableArray arrayWithCapacity:[PRODUCTS count]];
         NSLog(@"count products::: %d",[PRODUCTS count]);
         if(PRODUCTS != nil && [PRODUCTS count]>0){
             for( NSDictionary *attributes in PRODUCTS){
                 
                 Product *product=[Product parseProductJson:attributes];
                 [mutableProducts addObject:product];
                 
             }
             resultlist.products = mutableProducts;
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
