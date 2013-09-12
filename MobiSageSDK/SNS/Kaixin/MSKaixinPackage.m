//
//  MSKaixinPackage.m
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinPackage.h"


@implementation MSKaixinPackage
-(id)initWithAppKey:(NSString*)appKey
{
    self = [super init];
    if(self)
    {
        m_AppKey = [appKey retain];
        
        m_ParamDic = [NSMutableDictionary new];
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"snstype"];   //设置SNSTYPE为4：开心
        if(m_AppKey != nil){
            [m_ParamDic setObject:m_AppKey forKey:@"source"];
        }
    }
    return self;
}

-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString*)accessToken
{
    self = [super init];
    if(self)
    {
        m_AppKey = [appKey retain];
        m_AccessToken = [accessToken retain];
        
        m_ParamDic = [NSMutableDictionary new];
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"snstype"];
        if(m_AppKey != nil){
            [m_ParamDic setObject:m_AppKey forKey:@"source"];
        }
    }
    return self;
}

-(void)addParameter:(NSString*)name Value:(NSString*)value
{
    [m_ParamDic setObject:value forKey:name];
}

-(NSMutableURLRequest *)createURLRequest
{
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request setHTTPMethod:m_HttpMethod];
    
    if([m_HttpMethod isEqualToString:@"GET"])
    {
        
        NSMutableString* urlFullText = [NSMutableString new];
        [urlFullText appendString:m_UrlPath];
        
        for(NSInteger index=0; index < [[m_ParamDic allKeys] count]; index++)
        {
            id key = [[m_ParamDic allKeys] objectAtIndex:index];
            if(index == 0)
                [urlFullText appendFormat:@"?%@=%@",key,MobiSageUrlEncodedString([m_ParamDic objectForKey:key])];
            else
                [urlFullText appendFormat:@"&%@=%@",key,MobiSageUrlEncodedString([m_ParamDic objectForKey:key])];
        }
        
        [request setURL:[NSURL URLWithString:urlFullText]];
        MSSafeRelease(urlFullText);
    }
    else if([m_HttpMethod isEqualToString:@"POST"])
    {
        [request setURL:[NSURL URLWithString:m_UrlPath]];
        [self generateHTTPBody:request];
    }
    if(m_AccessToken != nil)
        [request addValue:[NSString stringWithFormat:@"OAuth2 %@",m_AccessToken] forHTTPHeaderField:@"Authorization"];
    
    return [request autorelease];
}

-(void)generateHTTPBody:(NSMutableURLRequest*)request
{    
    NSMutableString* queryText = [NSMutableString new];
    
    for(NSInteger index=0; index < [[m_ParamDic allKeys] count]; index++)
    {
        id key = [[m_ParamDic allKeys] objectAtIndex:index];
        if([queryText length] == 0)
            [queryText appendFormat:@"%@=%@",key,MobiSageUrlEncodedString([m_ParamDic objectForKey:key])];
        else
            [queryText appendFormat:@"&%@=%@",key,MobiSageUrlEncodedString([m_ParamDic objectForKey:key])];
    }
    
    NSData* bodyData = [queryText dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%l",[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    
    MSSafeRelease(queryText);
}

-(void)dealloc
{
    MSSafeRelease(m_ParamDic);
    MSSafeRelease(m_UrlPath);
    MSSafeRelease(m_HttpMethod);
    MSSafeRelease(m_AppKey);
    MSSafeRelease(m_AccessToken);
    [super dealloc];
}

@end
