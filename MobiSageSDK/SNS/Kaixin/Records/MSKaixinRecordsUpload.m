//
//  MSKaixinRecordsUpload.m
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinRecordsUpload.h"


@implementation MSKaixinRecordsUpload
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/records/add.json" retain];
        m_HttpMethod = [@"POST" retain];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        
        [m_paramInfo setObject:[NSNumber numberWithInt:4] forKey:@"actiontype"];
        [self processModuleAction:m_action];//发track
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
    if (![[m_ParamDic allKeys] containsObject:@"pic"]) {
        return [super generateHTTPBody:request];
    }
    //generate boundary string
    NSString *boundary = MobiSageGenerateGUID();
    [request addValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData* postdata = [NSMutableData new];
    
    [postdata appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    for(NSString* key in [m_ParamDic allKeys])
    {
        NSLog(@"m_ParamDic key&value:%@,%@",key,[m_ParamDic objectForKey:key]);
		[postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,[m_ParamDic objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
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

@end
