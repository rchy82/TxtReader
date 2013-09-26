#import <UIKit/UIKit.h>
#import "KDBook.h"
#import "PageView.h"
#import "RJBookData.h"
#import "RJBookIndexViewController.h"

@protocol KDBooKViewDelegate 

-(void)getAllPage;

@end

@interface KDBooKViewController : UIViewController <KDBookDelegate,BookReadDelegate>{
	
	PageView  *bookLabel;	
    
	KDBook   *mBook;
	NSUInteger bookIndex;
	UISlider *bookSlider;
	UIView   *headView;
    
    UIView *jumpToView; // 跳转控制条, 包含bookSlider
    UIButton *okJumpButton;
    UIButton *cancelJumpButton;
    int pageIndexBeforeJump; // 需要保存跳转前的值, 因为其他currentPage pageIndex无法保存
	
	NSUInteger  pageIndex;
    BOOL isNavHideflage;
    
    CGPoint gestureStartPoint;
    CGFloat currentLight;
    
    BOOL isShowIndex;
    
    int currentPage;
    int AllPage;
}

@property (nonatomic, readwrite)NSUInteger bookIndex;

-(void)back:(id)sender;
-(void) ShowHideNav;
-(void) HideNav;
-(void) doBookmark;
-(void) savePlace:(NSUInteger) nPage;
-(void) showPage;

//toolbar的响应事件
-(void) doJumpTo; // 跳转
-(void) okJumpButtonAction:(id) sender;
-(void) cancelJumpButtonAction:(id) sender;

-(void) doPre;
-(void) doFontColor;
-(void) doFontSize;
-(void) doLightLevel;
-(void) doNext;
-(void) doIndex;
-(void)showCurrentPage:(int)maxpage;

-(void) showHideJumpView;

@end
