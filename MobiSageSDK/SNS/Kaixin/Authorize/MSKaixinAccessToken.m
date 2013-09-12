//
//  MSKaixinAccessToken.m
//  MobiSageSDK
//
//  此处是用户获取Token的必经之路，所以可以在这里发用户的尝试登陆Track
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinAccessToken.h"

@implementation MSKaixinAccessToken
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret
{
    self = [super init];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/oauth2/access_token" retain];
        m_HttpMethod = [@"GET" retain];
        
        m_ParamDic = [NSMutableDictionary new];
        
        
        [m_ParamDic setObject:appKey forKey:@"client_id"];
        [m_ParamDic setObject:@"1" forKey:@"redirect_uri"];
        [m_ParamDic setObject:appSecret forKey:@"client_secret"];
        [m_ParamDic setObject:@"authorization_code" forKey:@"grant_type"];
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret Code:(NSString *)code
{
    self = [super init];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/oauth2/access_token" retain];
        m_HttpMethod = [@"GET" retain];
        
        m_ParamDic = [NSMutableDictionary new];
        

        [m_ParamDic setObject:appKey forKey:@"client_id"];
        [m_ParamDic setObject:@"1" forKey:@"redirect_uri"];
        [m_ParamDic setObject:appSecret forKey:@"client_secret"];
        [m_ParamDic setObject:@"authorization_code" forKey:@"grant_type"];
        [m_ParamDic setObject:code forKey:@"code"];
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
@end
