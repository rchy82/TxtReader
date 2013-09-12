//
//  MSKaixinAuthorize.m
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinAuthorize.h"

@implementation MSKaixinAuthorize
-(id)initWithAppKey:(NSString*)appKey
{
    self = [super initWithAppKey:appKey AccessToken:nil];
    if(self)
    {
        m_UrlPath = [@"http://api.kaixin001.com/oauth2/authorize" retain];
        m_HttpMethod = [@"GET" retain];
        
        
        [m_ParamDic setObject:appKey forKey:@"client_id"];
        [m_ParamDic setObject:@"" forKey:@"redirect_uri"];
        [m_ParamDic setObject:@"popup" forKey:@"display"];
        [m_ParamDic setObject:@"" forKey:@"state"];
        [m_ParamDic setObject:@"code" forKey:@"response_type"];
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}

@end
