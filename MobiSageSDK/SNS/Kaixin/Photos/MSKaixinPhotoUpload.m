//
//  MSKaixinPhotoUpload.m
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "MSKaixinPhotoUpload.h"


@implementation MSKaixinPhotoUpload
-(id)initWithAppKey:(NSString *)appKey AccessToken:(NSString *)accessToken
{
    self = [super initWithAppKey:appKey AccessToken:accessToken];
    if(self)
    {
        m_UrlPath = [@"https://api.kaixin001.com/photo/upload.json" retain];
        m_HttpMethod = [@"POST" retain];
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:accessToken forKey:@"oauth_token"];
        
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
    for(NSString* key in [m_ParamDic allKeys])
    {
		[postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,[m_ParamDic objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
        [postdata appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	//fill pic
	NSData *fileData = [NSData dataWithContentsOfFile:picPath];
    [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"pic\"; filename=\"%@\"\r\n",[picPath lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
    
	if ([[picPath pathExtension] isEqualToString:@"jpg"]) {
        [postdata appendData:[[NSString stringWithFormat:@"Content-Type:image/jpg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	else if ([[picPath pathExtension] isEqualToString:@"gif"]) {
        [postdata appendData:[[NSString stringWithFormat:@"Content-Type:image/gif\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	else if ([[picPath pathExtension] isEqualToString:@"png"]) {
        [postdata appendData:[[NSString stringWithFormat:@"Content-Type:image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	else if ([[picPath pathExtension] isEqualToString:@"jpeg"]) {
        [postdata appendData:[[NSString stringWithFormat:@"Content-Type:image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
	else if ([[picPath pathExtension] isEqualToString:@"bmp"]) {
        [postdata appendData:[[NSString stringWithFormat:@"Content-Type:image/bmp\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
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
