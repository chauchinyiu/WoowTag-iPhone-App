//
//  WoowTagToolKit.m
//  WoowTag
//
//  Created by Chau Chin Yiu on 7/24/12.
//  Copyright (c) 2012 Woow!Tag. All rights reserved.
//

#import "WoowTagToolKit.h"

@implementation WoowTagToolKit

+(NSString *) convertStringArrayToString:(NSArray *) arrays{
    NSString *tagsstring = @"";
    for(int i=0 ; i<[arrays count] ;i++ ){
        if(i==0){
            tagsstring  = [arrays objectAtIndex:i] ;
            
        }else{
            tagsstring = [NSString stringWithFormat:@"%@ , %@", tagsstring, [arrays objectAtIndex:i]];
        }
        NSLog( @"%@", [arrays objectAtIndex:i]  );
    }
    return tagsstring;
}
@end
