//
//  TencentAccessToken.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSTencentAccessToken.h"

@implementation MSTencentAccessToken
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret
{
    self = [super init];
    if(self)
    {
        m_UrlPath = [@"https://open.t.qq.com/cgi-bin/oauth2/access_token" retain];
        m_HttpMethod = [@"GET" retain];
        
        m_ParamDic = [NSMutableDictionary new];
        
        [m_ParamDic setObject:appKey forKey:@"client_id"];
        [m_ParamDic setObject:appSecret forKey:@"client_secret"];
        [m_ParamDic setObject:@"authorization_code" forKey:@"grant_type"];
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:1] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
@end
