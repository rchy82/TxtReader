//
//  MSTencentPicWeibo.m
//  TencentApiDemo
//
//  Created by 左 顺兴 on 12-5-25.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSTencentPicWeibo.h"


@implementation MSTencentPicWeibo

-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath= [@"https://open.t.qq.com/api/t/add_pic" retain];
        m_HttpMethod = [@"POST" retain];
        
        m_ParamDic = [NSMutableDictionary new];
        
        [m_ParamDic setObject:appKey forKey:@"oauth_consumer_key"];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:@"json" forKey:@"format"];
        [m_ParamDic setObject:@"2.a" forKey:@"oauth_version"];
        
        [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
        [m_paramInfo setObject:[NSNumber numberWithInt:1] forKey:@"snstype"];
        [m_paramInfo setObject:[NSNumber numberWithInt:5] forKey:@"actiontype"];
        [self processModuleAction:m_action];//此处执行的是用户上传照片的操作track，并不等于是否成功
        
    }
    return self;
}

-(void)addParameter:(NSString *)name Value:(NSString *)value
{
    if ([name isEqualToString:@"pic"]) {
        MSSafeRelease(picPath);
        picPath = [value retain];
        return;
    }
    [super addParameter:name Value:value];
}

-(void)generateHTTPBody:(NSMutableURLRequest *)request
{
    //generate boundary string
    NSString *boundary = MobiSageGenerateGUID();
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* postdata = [NSMutableData new];
    
    [postdata appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSArray* paramArray = [[self generateOAuthParameter] componentsSeparatedByString:@"&"];
    for(id param in paramArray)
    {
        NSArray* paramInfo = [param componentsSeparatedByString:@"="];
		[postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                               [paramInfo objectAtIndex:0],
                               MobiSageUrlDecodingString([paramInfo objectAtIndex:1])]
                              dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
	//fill pic
	NSData *fileData = [NSData dataWithContentsOfFile:picPath];
    [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",[picPath lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
    [postdata appendData:[@"Content-Type:application/octet-stream\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[postdata appendData:fileData];
    [postdata appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:postdata];
    [request addValue:[NSString stringWithFormat:@"%d", [postdata length]] forHTTPHeaderField:@"Content-Length"];
	MSSafeRelease(postdata);
}

@end
