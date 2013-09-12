//
//  MSKaixinAccessToken.h
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-4-19.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#import "../MSKaixinPackage.h"

@interface MSKaixinAccessToken : MSKaixinPackage

-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret;
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret Code:(NSString *)code;
@end
