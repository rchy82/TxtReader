//
//  RenrenAuthorize.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/9/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSRenrenAuthorize.h"

@implementation MSRenrenAuthorize
-(id)initWithClientID:(NSString *)clientID
{
    self = [super initWithClientID:clientID];
    if(self)
    {
        m_UrlPath = [@"https://graph.renren.com/oauth/authorize" retain];
        m_HttpMethod = [@"GET" retain];
        
        [m_ParamDic setObject:m_ClientID forKey:@"client_id"];
        [m_ParamDic setObject:@"code" forKey:@"response_type"];
        [m_ParamDic setObject:@"http://graph.renren.com/oauth/login_success.html" forKey:@"redirect_uri"];
        [m_ParamDic setObject:@"touch" forKey:@"display"];
        
        m_IsSignature = NO;
        
        
        [m_paramInfo setObject:clientID forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"snstype"];   //设置SNSTYPE为3：人人
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"actiontype"];
    }
    return self;
}

-(void)dealloc
{
    MSSafeRelease(m_ClientID);
    [super dealloc];
}
@end
