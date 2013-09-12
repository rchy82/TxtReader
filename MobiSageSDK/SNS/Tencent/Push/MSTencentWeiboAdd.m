//
//  MSTencentWeiboAdd.m
//  TencentApiDemo
//
//  Created by 左 顺兴 on 12-5-24.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSTencentWeiboAdd.h"

@implementation MSTencentWeiboAdd

-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath= [@"https://open.t.qq.com/api/t/add" retain];
        m_HttpMethod = [@"POST" retain];
        
        m_ParamDic = [NSMutableDictionary new];
        
        [m_ParamDic setObject:appKey forKey:@"oauth_consumer_key"];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:@"json" forKey:@"format"];
        [m_ParamDic setObject:@"2.a" forKey:@"oauth_version"];
        
        //以下为可选参数
//        [m_ParamDic setObject:@"all" forKey:@"scope"];
//        [m_ParamDic setObject:@"110.5" forKey:@"jing"];
//        [m_ParamDic setObject:@"23.4" forKey:@"wei"];
//        [m_ParamDic setObject:@"220.231.5.54" forKey:@"clintip"];
//        [m_ParamDic setObject:@"0" forKey:@"syncflag"];
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:1] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"actiontype"];
        [self processModuleAction:m_action];//发track
    }
    return self;
}
@end
