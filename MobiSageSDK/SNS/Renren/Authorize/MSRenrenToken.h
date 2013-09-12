//
//  RenrenToken.h
//  MobiSageSDK
//
//  Created by Ryou Zhang on 11/9/11.
//  Copyright (c) 2011 mobiSage. All rights reserved.
//

#import "../MSRenrenPackage.h"

@interface MSRenrenToken : MSRenrenPackage
{
@private
    NSString*   m_Secret;
    NSString*   m_Code;
}
-(id)initWithClientID:(NSString *)clientID ClientSecret:(NSString*)secret Code:(NSString*)code;
@end
