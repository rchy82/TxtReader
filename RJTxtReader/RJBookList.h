//
//  RJBookList.h
//  RJTxtReader
//
//  Created by Zeng Qingrong on 12-8-23.
//
//

#import <UIKit/UIKit.h>
#import "RJCommentView.h"
#import "RJBookData.h"
#import "RJAboutView.h"

@interface RJBookList : UIScrollView <UITableViewDelegate,UITableViewDataSource>

{
    UIScrollView* FirstView;
    RJAboutView* SecondView; // RJCommentView ahming 推荐页改为关于或帮助,设置等
    RJBookData* bookData;
    UITableView* bookTableView;
    BOOL isTableViewShow;
    UINavigationController* nc;
}

@property(nonatomic,assign) UINavigationController* nc;
-(void) initView;
-(void) doReadBook:(id)sender;
-(void) readBook:(NSInteger)i;
-(void) doTableViewShowOrHide;

@end
