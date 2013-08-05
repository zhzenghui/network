//
//  User.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "User.h"

static User *user;


@implementation User
@synthesize ID;
@synthesize name;
@synthesize email;
@synthesize content;
@synthesize role;
@synthesize created_at;
@synthesize updated_at;
@synthesize expiredDate;

+ (id)share
{
    if (user) {
        return user;
    }
    user = [[User alloc] init];


    return user;
}

- (id) init
{
    self = [super init];
    if (self)
    {
        [self reloadUserInfo];
    }
    return self;
}

- (User *)reloadUserInfo
{
    if ([KNSUserDefaults objectForKey:KCurrentUser]) {
        NSDictionary *userDict = [KNSUserDefaults objectForKey:KCurrentUser];
        [self dictToUser:userDict];
    }
    
    return self;
}

- (void)dealloc
{
    [ID release];
    [name release];
    [email release];
    [content release];
    [role release];
    [created_at release];
    [updated_at release];
    
    
    [super dealloc];
}


- (void)jsonToUser
{
    
}

- (void)insertUser
{

}

- (void)updateUser:(NSString *)userID
{
    
}

- (void)deleteUser:(NSString *)userID
{
    
}


- (NSDictionary *)userToDict:(User *)user
{
    NSMutableDictionary  *userDict = [NSMutableDictionary dictionary];
    
    
    
    return userDict;
}


- (User *)dictToUser:(NSDictionary *)userDict
{

    self.ID = [userDict objectForKey:@"id"];
    self.name = [userDict objectForKey:@"name"];
    self.email = [userDict objectForKey:@"email"];
    self.role = [userDict objectForKey:@"role"];
    self.content = [userDict objectForKey:@"content"];
    self.created_at = [userDict objectForKey:@"created_at"];
    self.updated_at = [userDict objectForKey:@"updated_at"];
    self.expiredDate = [userDict objectForKey:@"expiredDate"];
    
    return self;
}


- (void)saveCurrentUser:(NSDictionary *)userDict
{
    
    [userDict setValue:[NSDate stringFromDate:[NSDate date]] forKey:@"expiredDate"];

    [KNSUserDefaults setValue:userDict forKey:[userDict objectForKey:@"name"]];
    [KNSUserDefaults setValue:userDict forKey:KCurrentUser];
    
    [self reloadUserInfo];
}

- (void)deleteCurrentUser:(NSDictionary *)userDict
{
    [KNSUserDefaults setValue:nil forKey:[userDict objectForKey:@"name"]];
    [KNSUserDefaults setValue:nil forKey:KCurrentUser];
}

@end
