//
//  RenrenToken.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/9/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSRenrenToken.h"

@implementation MSRenrenToken
-(id)initWithClientID:(NSString *)clientID ClientSecret:(NSString *)secret Code:(NSString *)code
{
    self = [super initWithClientID:clientID];
    if(self)
    {
        m_UrlPath = [@"https://graph.renren.com/oauth/token" retain];
        m_HttpMethod = [@"GET" retain];
        
        m_Secret = [secret retain];
        m_Code = [code retain];
        
        [m_ParamDic setObject:m_ClientID forKey:@"client_id"];
        [m_ParamDic setObject:m_Secret forKey:@"client_secret"];
        [m_ParamDic setObject:m_Code forKey:@"code"];
        [m_ParamDic setObject:@"authorization_code" forKey:@"grant_type"];
        [m_ParamDic setObject:@"http://graph.renren.com/oauth/login_success.html" forKey:@"redirect_uri"];
        m_IsSignature = NO;
        
        [m_paramInfo setObject:clientID forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"snstype"];   //设置SNSTYPE为3：人人
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
-(void)dealloc
{
    MSSafeRelease(m_Secret);
    MSSafeRelease(m_Code);
    [super dealloc];
}
@end
