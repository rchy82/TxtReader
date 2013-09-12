//
//  SinaFriendshipsDestroy.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MSSinaFriendshipsDestroy.h"

@implementation MSSinaFriendshipsDestroy
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.weibo.com/2/friendships/destroy.json" retain];
        m_HttpMethod = [@"POST" retain];
    }
    return self;
}
@end
