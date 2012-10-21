//
//  Product.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/4/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "Product.h"
//@interface Product()
//+(Product*) parseProductJson:(NSDictionary *)  attributes  ;
//@end
@implementation Product

@synthesize productId;
@synthesize name;
@synthesize price;
@synthesize stock;
@synthesize store;
@synthesize rate;
@synthesize imagelinks;
@synthesize description;
@synthesize tags;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



// get the product detail 
+ (void)callDetailWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(Product *product))block { 
    
    
	NSMutableURLRequest *request = [[WebServiceClient sharedClient]  requestWithMethod:@"GET" path:webservicename parameters:parameter];
    [request setTimeoutInterval:5];
    AFHTTPRequestOperation *operation = [[WebServiceClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id JSON){
        
        NSDictionary* productDict = [JSON valueForKeyPath:@"product"];
        NSLog(@"JSON: %@ ",  productDict ) ;
        
        Product *product=[Product parseProductJson:productDict];
        
        if (block) {
            block(product);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil);
        }
    }];
    
    [[WebServiceClient sharedClient]  enqueueHTTPRequestOperation:operation];
    
}

+(Product*) parseProductJson:(NSDictionary *)  attributes  {
    Product *tempproduct =  [[Product alloc] init];
    tempproduct.productId = [attributes valueForKeyPath:@"id"];
    tempproduct.name= [attributes valueForKeyPath:@"name"];
    tempproduct.price = [attributes valueForKeyPath:@"price"] ;
    tempproduct.stock  = [attributes valueForKeyPath:@"stock"] ;
    tempproduct.rate  =  [attributes valueForKeyPath:@"rate"] ;
    tempproduct.description = [attributes valueForKeyPath:@"description"] ;
    tempproduct.tags = [attributes valueForKey:@"tags"];
    NSDictionary *storedict = [attributes valueForKeyPath:@"store"];
    if(storedict){
        Store *tempstore=  [[Store alloc] init];
        tempstore.storeId = [storedict valueForKeyPath:@"id"];
        tempstore.name = [storedict valueForKeyPath:@"name"];
        tempstore.address = [storedict valueForKeyPath:@"address"];
        tempstore.phone = [storedict valueForKeyPath:@"phone"];
        tempstore.fax = [storedict valueForKeyPath:@"fax"];
        tempstore.description = [storedict valueForKeyPath:@"description"];
        tempstore.store_url = [storedict valueForKeyPath:@"store_url"];
        tempstore.latitude = [storedict valueForKeyPath:@"latitude"];
        tempstore.longitude = [storedict valueForKeyPath:@"longitude"];
        NSDictionary *storeimage  = [storedict valueForKeyPath:@"images"];
        if([storeimage count]){
            for(NSDictionary *imageattr in storeimage){
                NSString *str = [imageattr valueForKeyPath:@"file_name"] ;
                if(str != nil ){
                    tempstore.imageUrl = str;
                }
                break;
            }
            
        }
        
        tempstore.tags = [storedict valueForKey:@"tags"];
        tempproduct.store = tempstore;
    }
    NSDictionary *imagesDict =  [attributes valueForKeyPath:@"images"] ;
    if([imagesDict count]){
        NSMutableArray *mutableImages = [NSMutableArray arrayWithCapacity:[imagesDict count]];
        for(NSDictionary *imageattr in imagesDict){
            [mutableImages addObject:[imageattr valueForKeyPath:@"file_name"]];
        }
        tempproduct.imagelinks = [NSArray arrayWithArray:mutableImages];
    }
    
    return tempproduct;
}

-(NSString *) convertTagsToString {
    NSString *tagsstring = @"";
    for(int i=0 ; i<[self.tags count] ;i++ ){
        if(i==0){
            tagsstring  = [self.tags objectAtIndex:i] ;
            
        }else{
            tagsstring = [NSString stringWithFormat:@"%@ , %@", tagsstring, [self.tags objectAtIndex:i]];
        }
        NSLog( @"%@", [self.tags objectAtIndex:i]  );
    }
    return tagsstring;
}

@end
