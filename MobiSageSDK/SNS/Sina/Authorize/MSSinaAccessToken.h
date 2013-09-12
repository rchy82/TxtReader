//
//  SinaAccessToken.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 10/23/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "../MSSinaWeiboPackage.h"

@interface MSSinaAccessToken : MSSinaWeiboPackage
{
    
}
-(id)initWithAppKey:(NSString*)appKey Secret:(NSString*)appSecret;
@end
