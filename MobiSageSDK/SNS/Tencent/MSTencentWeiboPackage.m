//
//  TencentWeiboPackage.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSTencentWeiboPackage.h"

@implementation MSTencentWeiboPackage
-(id)initWithAppKey:(NSString*)appKey
{
    self = [super init];
    if(self)
    {
        m_AppKey = [appKey retain];
        
        m_ParamDic = [NSMutableDictionary new];
        
        [m_paramInfo setObject:[NSNumber numberWithInt:1] forKey:@"snstype"];
        if(m_AppKey != nil){
            [m_ParamDic setObject:m_AppKey forKey:@"appkey"];
            [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
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
        
        [m_paramInfo setObject:[NSNumber numberWithInt:1] forKey:@"snstype"];
        if(m_AppKey != nil){
            [m_ParamDic setObject:m_AppKey forKey:@"appkey"];
            [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
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
    NSString* queryText = [[self generateOAuthParameter] retain];    
    NSData* bodyData = [queryText dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%l",[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    NSLog(@"request:%@;queryText:%@",request,queryText);
    MSSafeRelease(queryText);
}

-(NSString*)generateOAuthParameter
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
	return [queryText autorelease];
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
