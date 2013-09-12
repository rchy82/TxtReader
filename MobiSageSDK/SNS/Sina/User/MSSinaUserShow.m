//
//  SinaUserShow.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSSinaUserShow.h"

@implementation MSSinaUserShow
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.weibo.com/2/users/show.json" retain];
        m_HttpMethod = [@"GET" retain];
    }
    return self;
}
@end
