//
//  SinaFriendshipCreate.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/3/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSSinaFriendshipCreate.h"

@implementation MSSinaFriendshipCreate
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.weibo.com/2/friendships/create.json" retain];
        m_HttpMethod = [@"POST" retain];
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}
@end
