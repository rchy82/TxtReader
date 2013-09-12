//
//  MSKaixinPackage.h
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MobiSageSNSPackage.h"

@interface MSKaixinPackage : MobiSageSNSPackage
{
@protected
    NSString*               m_AppKey;
    NSString*               m_AccessToken;
    
    NSString*               m_UrlPath;
    NSString*               m_HttpMethod;
    
    NSMutableDictionary*    m_ParamDic;
}
-(id)initWithAppKey:(NSString*)appKey;
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString*)accessToken;

-(void)addParameter:(NSString*)name Value:(NSString*)value;

-(void)generateHTTPBody:(NSMutableURLRequest*)request;
@end
