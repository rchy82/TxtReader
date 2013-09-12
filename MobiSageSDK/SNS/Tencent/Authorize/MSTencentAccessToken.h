//
//  TencentAccessToken.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "../MSTencentWeiboPackage.h"

@interface MSTencentAccessToken : MSTencentWeiboPackage
{
    
}
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret;
@end
