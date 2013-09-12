//
//  RenrenPackage.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/9/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSRenrenPackage.h"


@interface MSRenrenPackage(PrivateMethod)
-(void)generateSignature;
@end


@implementation MSRenrenPackage
-(id)initWithClientID:(NSString*)clientID
{
    self = [super init];
    [m_paramInfo setObject:clientID forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
    [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"snstype"];   //设置SNSTYPE为3：人人
    if(self)
    {
        m_ClientID = [clientID retain];
        m_ParamDic = [NSMutableDictionary new];
        
        m_IsSignature = NO;
    }
    return self;
}

-(id)initWithAccessToken:(NSString*)accessToken SecretKey:(NSString*)secretKey clientID:(NSString *)clientID
{
    self = [super init];
    [m_paramInfo setObject:clientID forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
    [m_paramInfo setObject:[NSNumber numberWithInt:3] forKey:@"snstype"];   //设置SNSTYPE为3：人人
    if(self)
    {
        m_AccessToken = [accessToken retain];
        m_SecretKey = [secretKey retain];
        m_ParamDic = [NSMutableDictionary new];
        
        m_IsSignature = YES;
    }
    return self;    
}

-(void)addParameter:(NSString*)name Value:(NSString*)value
{
    [m_ParamDic setObject:value forKey:name];
}

-(void)generateSignature
{
    NSMutableArray* result = [NSMutableArray new];    
    for(NSString* key in [m_ParamDic allKeys])
        [result addObject:[NSString stringWithFormat:@"%@=%@",key,[m_ParamDic valueForKey:key]]];
    
    NSArray *sortedPairs = [result sortedArrayUsingSelector:@selector(compare:)];
    NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@""];
	MSSafeRelease(result);
    [m_ParamDic setObject:MobiSageMD5([normalizedRequestParameters stringByAppendingString:m_SecretKey]) forKey:@"sig"];
}

-(NSMutableURLRequest *)createURLRequest
{
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request setHTTPMethod:m_HttpMethod];
    
    if(m_IsSignature)
        [self generateSignature];
    
    if([m_HttpMethod isEqualToString:@"GET"])
    {
        NSMutableString* queryText = [NSMutableString new];
        for(id key in [m_ParamDic allKeys])
        {
            if([queryText length] == 0)
                [queryText appendFormat:@"%@=%@",key,MobiSageUrlEncodedString([m_ParamDic objectForKey:key])];
            else
                [queryText appendFormat:@"&%@=%@",key,MobiSageUrlEncodedString([m_ParamDic objectForKey:key])];
        }
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",m_UrlPath,queryText]]];
        MSSafeRelease(queryText);
    }
    else if([m_HttpMethod isEqualToString:@"POST"])
    {
        [request setURL:[NSURL URLWithString:m_UrlPath]];
        [self generateHTTPBody:request];
    }
    return [request autorelease];
}

-(void)generateHTTPBody:(NSMutableURLRequest*)request
{
    NSMutableString* queryText = [NSMutableString new];
    for(id key in [m_ParamDic allKeys])
    {
        if([queryText length] == 0)
            [queryText appendFormat:@"%@=%@",key,[m_ParamDic objectForKey:key]];
        else
            [queryText appendFormat:@"&%@=%@",key,[m_ParamDic objectForKey:key]];
    }
    NSData* bodyData = [queryText dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%l",[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    MSSafeRelease(queryText); 
}

-(void)dealloc
{
    MSSafeRelease(m_ClientID);
    MSSafeRelease(m_SecretKey);
    MSSafeRelease(m_AccessToken);
    MSSafeRelease(m_ParamDic);
    MSSafeRelease(m_HttpMethod);
    MSSafeRelease(m_UrlPath);
    [super dealloc];
}
@end
