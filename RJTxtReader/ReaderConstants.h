//
//  ReaderConstants.h
//  RJTxtReader
//
//  Created by ahming on 13-9-12.
//
//

#import <Foundation/Foundation.h>


// 移自 RJTxtReader-Prefix.pch // 480
#define myHight [UIScreen mainScreen].bounds.size.height

// 编译选项开始:

// 是否显示状态栏(或是否全屏), 后期考虑作为设置加入
#define RJ_UI_FULLSCREEN 1

// 阅读界面, 切换跳转控制条一直显示在底部(1)还是位于屏幕中间(0) ahming-marks-page
#define RJ_UI_BOOK_SLIDER_ALWAYS_SHOWN_ON_BOTTOM 0
// 跳转控制条在底部时的高度, 为零时不显示
#if RJ_UI_BOOK_SLIDER_ALWAYS_SHOWN_ON_BOTTOM
  #define RJ_UI_BOOK_SLIDER_HEIGHT_ON_BOTTOM 20
#else
  #define RJ_UI_BOOK_SLIDER_HEIGHT_ON_BOTTOM 0
#endif

// 阅读界面, 切换是否显示广告并设置相关广告位置
// 若设置了广告位置, 在适当地方添加好后注意调整此处高度
#define RJ_UI_BOOK_VIEW_ADS_ON_BOTTOM 0

#if RJ_UI_BOOK_VIEW_ADS_ON_BOTTOM
  #define RJ_UI_BOOK_VIEW_ADS_HEIGHT_ON_BOTTOM 50
#else
  #define RJ_UI_BOOK_VIEW_ADS_HEIGHT_ON_BOTTOM 0
#endif


//#### NSUserDefaults
//#### refs: Viewer.xcodeproj
//####

extern NSString *const kReaderCopyrightNotice;

extern NSString *const kReaderSettingsAppVersion;
//extern NSString *const kReaderSettingsCurrentFolder;
//extern NSString *const kReaderSettingsCurrentDocument;
extern NSString *const kReaderSettingsHideStatusBar; // 目前只完成程序启动初始化, 未应用

extern NSString *const kReaderSettingTextColorIndex;
extern NSString *const kReaderSettingTextFontSizeIndex;
