//
//  RenrenFriendsGetFriends.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MSRenrenFriendsGetFriends.h"

@implementation MSRenrenFriendsGetFriends
-(id)initWithAccessToken:(NSString *)accessToken SecretKey:(NSString *)secretKey clientID:(NSString *)clientID
{
    self = [super initWithAccessToken:accessToken SecretKey:secretKey clientID:clientID];
    if(self)
    {
        m_UrlPath = [@"http://api.renren.com/restserver.do" retain];
        m_HttpMethod = [@"POST" retain];
        
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:@"2.0" forKey:@"v"];
        [m_ParamDic setObject:@"friends.getFriends" forKey:@"method"];
        [m_ParamDic setObject:@"json" forKey:@"format"];
    }
    return self;
}
@end
