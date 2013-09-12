//
//  RenrenPackage.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/9/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MobiSageSNSPackage.h"

@interface MSRenrenPackage : MobiSageSNSPackage
{
@protected
    NSString*               m_ClientID;
    NSString*               m_SecretKey;
    NSString*               m_AccessToken;
    
    NSString*               m_UrlPath;
    NSString*               m_HttpMethod;
    
    BOOL                    m_IsSignature;
    NSMutableDictionary*    m_ParamDic;
}
-(id)initWithClientID:(NSString*)clientID;
-(id)initWithAccessToken:(NSString*)accessToken SecretKey:(NSString*)secretKey clientID:(NSString*)clientID;

-(void)addParameter:(NSString*)name Value:(NSString*)value;

-(void)generateHTTPBody:(NSMutableURLRequest*)request;
@end
