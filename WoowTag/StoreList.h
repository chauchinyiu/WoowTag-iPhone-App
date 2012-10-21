//
//  StoreList.h
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/25/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreList : NSObject
@property (nonatomic, retain) NSString * totalnums;
@property (nonatomic, retain) NSMutableArray * stores;
@property (nonatomic, retain) NSString * status;
+ (void)callListWebService:(NSString*) webservicename withParameter:(NSDictionary*) parameter WithBlock:(void (^)(StoreList *storelist))block ;

@end
