#import <UIKit/UIKit.h>
#import "KDBook.h"
#import "PageView.h"
#import "RJBookData.h"
#import "RJBookIndexViewController.h"
#import "MobiSageSDK.h"


@protocol KDBooKViewDelegate 

-(void)getAllPage;

@end

@interface KDBooKViewController : UIViewController <KDBookDelegate,BookReadDelegate,MobiSageAdBannerDelegate>{
	
	PageView  *bookLabel;	
    
	KDBook   *mBook;
	NSUInteger bookIndex;
	UISlider *bookSlider;
	UIView   *headView;
	
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
-(void) doPre;
-(void) doFont;
-(void) doColor;
-(void) doNext;
-(void) doIndex;
-(void)showCurrentPage:(int)maxpage;

@end
