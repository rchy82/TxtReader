//
//  RenrenPhototsUpload.m
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MSRenrenPhototsUpload.h"


@implementation MSRenrenPhototsUpload
-(id)initWithAccessToken:(NSString *)accessToken SecretKey:(NSString *)secretKey clientID:(NSString *)clientID
{
    self = [super initWithAccessToken:accessToken SecretKey:secretKey clientID:clientID];
    if(self)
    {
        m_UrlPath = [@"http://api.renren.com/restserver.do" retain];
        m_HttpMethod = [@"POST" retain];
        
        [m_ParamDic setObject:accessToken forKey:@"access_token"];
        [m_ParamDic setObject:@"2.0" forKey:@"v"];
        [m_ParamDic setObject:@"photos.upload" forKey:@"method"];
        [m_ParamDic setObject:@"json" forKey:@"format"];
        [m_paramInfo setObject:[NSNumber numberWithInt:5] forKey:@"actiontype"];
        [self processModuleAction:m_action];
    }
    return self;
}

-(void)addParameter:(NSString *)name Value:(NSString *)value
{
    if([name isEqualToString:@"upload"])
    {
        MSSafeRelease(picPath);
        picPath = [value retain];
    }
    else
        [m_ParamDic setObject:value forKey:name];
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
    [postdata appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"upload\"; filename=\"%@\"\r\n",[picPath lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
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
