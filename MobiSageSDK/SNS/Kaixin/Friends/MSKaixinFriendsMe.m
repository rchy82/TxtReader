//
//  MSKaixinFriendsMe.m
//  MobiSageSDK
//  
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinFriendsMe.h"

@implementation MSKaixinFriendsMe
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/friends/me.json" retain];
        m_HttpMethod = [@"GET" retain];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
@end
