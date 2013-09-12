//
//  MSKaixinPageAddFan.m
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinPageAddFan.h"

@implementation MSKaixinPageAddFan
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/page/add_fan.json" retain];
        m_HttpMethod = [@"POST" retain];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
@end
