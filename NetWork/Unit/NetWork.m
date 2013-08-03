//
//  NetWork.m
//  NetWork
//
//  Created by mbp  on 13-8-2.
//  Copyright (c) 2013年 zeng hui. All rights reserved.
//

#import "NetWork.h"
#import "Reachability.h"


static NetWork *netWork;
@implementation NetWork

@synthesize isConnect = _isConnect;

- (id) init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}


+ (id)shareNetWork
{
    if (netWork) {
        return netWork;
    }
    netWork = [[NetWork alloc] init];
    return netWork;
}



-(BOOL)CheckNetwork   {
    Reachability * reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    NetworkStatus networkStatus = [reach currentReachabilityStatus];
    
    if ( networkStatus == NotReachable ) {
        _isConnect = NO;
        return NO;
    }
    else {
        _isConnect = YES;
        return YES;
    }
    return YES;
}

/* 检查本地是否存在用户信息
 *
 */
- (void)checkLocalUserInfo:(NSString *)userName
{
    
}

/* 检查本地用户信息过期
 
 */
- (void)checkLocalUserInfoExpired:(NSString *)userName
{
    
}

/*  检查本地数据Version
 *  如果第一次登陆isFirstLogin=YES
 *  不允许跳过更新
 */
- (void)checkLocalIsFirstVersion
{
    
}

- (void)login
{
    
}

- (void)getInfo
{
    
}

@end
