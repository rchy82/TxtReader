//
//  SinaStatusUpdate.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSSinaStatusUpdate.h"

@implementation MSSinaStatusUpdate
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath= [@"https://api.weibo.com/2/statuses/update.json" retain];
        m_HttpMethod = [@"POST" retain];
        
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"actiontype"];
        [self processModuleAction:m_action];//发track
    }
    return self;
}
@end
