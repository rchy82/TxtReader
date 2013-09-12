//
//  MSKaixinAlbumShow.m
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinAlbumShow.h"

@implementation MSKaixinAlbumShow
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/album/show.json" retain];
        m_HttpMethod = [@"GET" retain];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:accessToken forKey:@"oauth_token"];
        
        [m_paramInfo setObject:[NSNumber numberWithInt:6] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;

}
@end
