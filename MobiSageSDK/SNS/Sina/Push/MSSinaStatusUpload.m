//
//  SinaStatusUpload.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "MSSinaStatusUpload.h"


@implementation MSSinaStatusUpload
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    
    if(self)
    {
        m_UrlPath = [@"https://api.weibo.com/2/statuses/upload.json" retain];
        m_HttpMethod = [@"POST" retain];
    }
    
    [m_paramInfo setObject:appKey forKey:@"appkey"];    //设置Track参数：开发者的APPKEY
    [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"actiontype"];
    [m_paramInfo setObject:[NSNumber numberWithInt:2] forKey:@"snstype"];
    [self processModuleAction:m_action];//发track
    
    return self;
}

-(void)addParameter:(NSString *)name Value:(NSString *)value
{
    if([name isEqualToString:@"pic"])
    {
        MSSafeRelease(picPath);
        picPath = [value retain];
    }
    else
    {
        [m_ParamDic setObject:value forKey:name];
    }
}

-(void)generateHTTPBody:(NSMutableURLRequest *)request
{
    //generate boundary string
    NSString *boundary = MobiSageGenerateGUID();
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* postdata = [NSMutableData new];
    
    [postdata appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    for(NSString* key in [m_ParamDic allKeys])
    {
		[postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,[m_ParamDic objectForKey:key]]
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
    [request addValue:[NSString stringWithFormat:@"%l", [postdata length]] forHTTPHeaderField:@"Content-Length"];
	MSSafeRelease(postdata);
}

-(void)dealloc
{
    MSSafeRelease(picPath);
    [super dealloc];
}
@end
