//
//  RJBookListViewController.m
//  RJTxtReader
//
//  Created by joey on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReaderConstants.h"
#import "RJBookListViewController.h"


@interface RJBookListViewController ()

@end

@implementation RJBookListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    UIView* aView = [navBar.subviews objectAtIndex:0];
    aView.hidden = YES;
    
    [self.navigationController setToolbarHidden:YES animated:TRUE];

    CGRect rect = CGRectMake(140, 0, 40, 44);
    UILabel *titleView = [[UILabel alloc] initWithFrame:rect];
    titleView.opaque = YES;
    titleView.backgroundColor = [UIColor clearColor];
    titleView.text = @"书架";
    titleView.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = titleView;
    [titleView release];
    
   //yu mark 去除导航栏左右两菜单 -> ahming uncommented 推荐页改为关于或帮助,设置等
    UIImage* image= [UIImage imageNamed:@"button.png"];
    CGRect frame_1= CGRectMake(5, 5, 80, 30);
    
    UIButton* leftButton= [[UIButton alloc] initWithFrame:frame_1];
    [leftButton setBackgroundImage:image forState:UIControlStateNormal];
    [leftButton setTitle:@"列表" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [leftButton addTarget:self action:@selector(doList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(doList:)];
    leftItem.customView = leftButton;
    [leftButton release];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    

    UIButton* rightButton= [[UIButton alloc] initWithFrame:frame_1];
    [rightButton setBackgroundImage:image forState:UIControlStateNormal];
    [rightButton setTitle:@"关于" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(doComment:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"关于" style:UIBarButtonItemStyleBordered target:self action:@selector(doComment)];
    rightItem.customView = rightButton;
    [rightButton release];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    
    rect = CGRectMake(0, 0, self.view.bounds.size.width, myHight); // ahming marks 最初有 -20 yu fixed
    self.view.frame = rect;
    listView = [[RJBookList alloc]initWithFrame:rect];
    listView.contentSize = CGSizeMake(self.view.bounds.size.width*2, myHight); // ahming removed -20
    listView.pagingEnabled = YES;
    // listView.scrollEnabled = NO; //yu mark 禁止左右滑动 -> ahming 推荐页改为关于或帮助,设置等, 最初没这行
    listView.delegate = self;
    listView.backgroundColor =[UIColor blackColor]; // ahming marks: yu added
    listView.nc = self.navigationController;
    [self.view addSubview:listView];
    [listView release];
  
  //yu mark 去除主界面翻页白点
//    rect = CGRectMake(150, myHight-35, 20, 10);
//    pageControl = [[UIPageControl alloc] initWithFrame:rect];
//    pageControl.numberOfPages = 2;
//    pageControl.currentPage = 0;
//    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:pageControl];
//    [pageControl release];
}



//yu mark 以下代码为主界面其他功能，暂时无功能需求去掉 -> ahming 代码空间占用不大，保留不调用即可，方便后续修改

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = listView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
    
    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    
    if(listView.contentOffset.x > 160)
    {
        [rightButton setTitle:@"返回" forState:UIControlStateNormal];
        ((UILabel*)self.navigationItem.titleView).text = @"关于";
    }
    else
    {
        [rightButton setTitle:@"关于" forState:UIControlStateNormal];
        ((UILabel*)self.navigationItem.titleView).text = @"书架";
    }
}

- (IBAction)doList:(id)sender
{
    if(listView.contentOffset.x > 0)
    {
        [self gotoPage:0];
    }
    [listView doTableViewShowOrHide];
    UILabel* titlView = (UILabel*)self.navigationItem.titleView;
    UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    if([leftButton.titleLabel.text isEqualToString: @"书架"])
    {
        titlView.text = @"书架";
        [leftButton setTitle:@"列表" forState:UIControlStateNormal];
    }
    else
    {
        titlView.text = @"列表";
        [leftButton setTitle:@"书架" forState:UIControlStateNormal];
    }
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [self gotoPage:page];
}

- (IBAction)doComment:(id)sender
{
    if(listView.contentOffset.x /320 == 0)
        [self gotoPage:1];
    else
        [self gotoPage:0];
}

- (void) gotoPage:(int) pageNum
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [listView setContentOffset:CGPointMake(320 * pageNum, 0)];
    [UIView commitAnimations];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
