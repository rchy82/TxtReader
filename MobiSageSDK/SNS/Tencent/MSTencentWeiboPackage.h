//
//  TencentWeiboPackage.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MobiSageSNSPackage.h"

@interface MSTencentWeiboPackage : MobiSageSNSPackage
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

-(void)generateHTTPBody:(NSMutableURLRequest*)request;

-(NSString*)generateOAuthParameter;

-(void)addParameter:(NSString*)name Value:(NSString*)value;
@end
