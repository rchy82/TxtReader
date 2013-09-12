//
//  RenrenStatusSet.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/9/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSRenrenStatusSet.h"

@implementation MSRenrenStatusSet
-(id)initWithAccessToken:(NSString *)accessToken SecretKey:(NSString *)secretKey clientID:(NSString *)clientID
{
    self = [super initWithAccessToken:accessToken SecretKey:secretKey clientID:clientID];
    if(self)
    {
        m_UrlPath = [@"http://api.renren.com/restserver.do" retain];
        m_HttpMethod = [@"POST" retain];
        
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:@"2.0" forKey:@"v"];
        [m_ParamDic setObject:@"status.set" forKey:@"method"];
        [m_ParamDic setObject:@"json" forKey:@"format"];
        
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"snstype"];   //设置SNSTYPE为3：人人
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"actiontype"];
        [self processModuleAction:m_action];//发track
    }
    return self;
}
@end
