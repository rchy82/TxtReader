//
//  MobiSageSNSPackage.h
//  MobiSageSDK
//
//  Created by 左 顺兴 on 12-5-16.
//  Copyright (c) 2012年 mobiSage. All rights reserved.
//

#ifndef MSSafeRelease
#define MSSafeRelease(obj) if(obj!=nil){[obj release]; obj=nil;}
#endif



#import "MobiSageSDK.h"

@class MobiSageAction;


@interface MobiSageSNSPackage : MobiSagePackage
{
@protected
    
    MobiSageAction*         m_action;
    NSMutableDictionary*    m_paramInfo;
}
- (void)processModuleAction:(MobiSageAction*)action;
@end
