//
//  WebService.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 6/9/12.
//  Copyright 2012 WoowTag. All rights reserved.
//

#import "WebServiceClient.h"
#import "WoowTagContstant.h"
#import "AFJSONRequestOperation.h"
@implementation WebServiceClient

+ (WebServiceClient *)sharedClient {
    static WebServiceClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WebServiceClient alloc] initWithBaseURL:[NSURL URLWithString:SEARCH_PRODUCT_URL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}
 
#pragma mark -
 
     



@end
