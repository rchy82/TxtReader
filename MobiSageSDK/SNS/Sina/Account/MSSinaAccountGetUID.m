//
//  SinaAccountGetUID.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSSinaAccountGetUID.h"

@implementation MSSinaAccountGetUID
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.weibo.com/2/account/get_uid.json" retain];
        m_HttpMethod = [@"GET" retain];
    }
    return self;
}
@end
