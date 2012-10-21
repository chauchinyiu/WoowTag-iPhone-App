//
//  WebService.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/9/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import <Foundation/Foundation.h>
 
#import "AFHTTPClient.h"
#import "Product.h"
@interface WebServiceClient : AFHTTPClient   {
   
}
+ (WebServiceClient *)sharedClient ;

@end
