//
//  ZHPassDataJSON.m
//  NetWork
//
//  Created by mbp  on 13-8-9.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "ZHPassDataJSON.h"

#import "ZHdyrsModel.h"



@implementation ZHPassDataJSON


#pragma mark - user

- (void)userDictToDB:(NSDictionary *)userDict
{
//      dict   to   sql   db
    
    
}

- (void)userArrayToDB:(NSArray *)array
{
    for (NSDictionary *userDict in array) {
        
        [self userDictToDB:userDict];
    }
}


#pragma mark - data to pass


- (void)dataToModel:(NSDictionary *)dataDict
{
    NSDictionary *modelDict = [dataDict objectForKey:0];
    
    
    
    if ([[modelDict objectForKey:@"table"] isEqualToString:@"user"])
    {
        
        [self userArrayToDB:[modelDict objectForKey:0]];
        
    }
    else if ([[modelDict objectForKey:@"table"] isEqualToString:@"setting"])
    {
        
        
        
    }
    
}

- (void)dyrsJsonToDB:(NSArray *)array
{
    NSDictionary *statueDict = [array objectAtIndex:0];
    
//   statue   1   返回成功
    
    if ([[statueDict objectForKey:@"statue"] isEqualToString:@"1"]) {
        
        NSDictionary *dataDict = [array objectAtIndex:1];
        
        [self dataToModel:dataDict];
        
    }
    else {
        
        NSLog(@"返回 statue：  %@ \n", [statueDict objectForKey:@"statue"] );
    }
    
    
}
@end
