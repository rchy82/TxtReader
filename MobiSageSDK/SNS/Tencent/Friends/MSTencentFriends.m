//
//  MSTencentFriends.m
//  TencentApiDemo
//
//  Created by 左 顺兴 on 12-5-24.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSTencentFriends.h"

@implementation MSTencentFriends
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://open.t.qq.com/api/friends/add" retain];
        m_HttpMethod = [@"POST" retain];
        
        [m_ParamDic setObject:appKey forKey:@"oauth_consumer_key"];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:@"json" forKey:@"format"];
        [m_ParamDic setObject:@"2.a" forKey:@"oauth_version"];
        
        if (appKey != nil) {
            [m_paramInfo setObject:appKey forKey:@"appkey"];
        }
        [m_paramInfo setObject:[NSNumber numberWithInt:1] forKey:@"snstype"];   //设置SNSTYPE为1：腾讯
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
@end
