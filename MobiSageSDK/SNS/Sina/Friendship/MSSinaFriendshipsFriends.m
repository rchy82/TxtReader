//
//  SinaFriendshipsFriends.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MSSinaFriendshipsFriends.h"

@implementation MSSinaFriendshipsFriends
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.weibo.com/2/friendships/friends.json" retain];
        m_HttpMethod = [@"GET" retain];
    }
    return self;
}
@end
