

#import "ReaderConstants.h"
#import "KDBooKViewController.h"


@implementation KDBooKViewController
@synthesize bookIndex;

- (void)exchangeAnimate:(NSInteger)add{
	[UIView beginAnimations:@"animationID" context:nil];
	[UIView setAnimationDuration:1.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationRepeatAutoreverses:NO];
	switch (2+add) {
		case 0:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:bookLabel cache:YES];//oglFlip, fromLeft 
			break;
		case 1:
			[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:bookLabel cache:YES];//oglFlip, fromRight 	 
			break;
		case 2:
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:bookLabel cache:YES];
			break;
		case 3:
			[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:bookLabel cache:YES];
			break;
		default:
			break;
	}
    
	[UIView commitAnimations];
}

-(void) savePlace:(NSUInteger) nPage
{
    pageIndexBeforeJump = nPage;
    
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    [saveDefaults setInteger:nPage forKey:singleBook.name];
}


- (void)sliderEvent{
    
   	NSUInteger page = bookSlider.value;
	pageIndex = page;
	bookLabel.text = [mBook stringWithPage:pageIndex];
   [self showCurrentPage:AllPage];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showCurrentPage:AllPage];
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self.view];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];
    
    CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x);
    CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);
  
    if (deltaX < 10 && deltaY < 10) { //单击
        
        [self ShowHideNav];
        
        // 单击时当作确认跳转
        if ( ![jumpToView isHidden] ) {
            [self savePlace:bookSlider.value];
            [jumpToView setHidden:YES];
        }
        
        if (isNavHideflage == NO)
        {
            [self performSelector:@selector(HideNav) withObject:self afterDelay:10.0];
        }
        return;
    }
    if(deltaX > deltaY)
    {
        if (mBook.isPaginating != RJ_PAGINATING_STATE_UPDATE_RUNNING) { //
            if(gestureStartPoint.x < currentPosition.x) //从左往右，往前翻页
            {
                [self doPre];
            }
            else
            {
                [self doNext];
            }
        }
    }
}


-(void) HideNav
{
    if(isNavHideflage == NO && isShowIndex == NO)
    {
        [self ShowHideNav];
    }
}

-(void) ShowHideNav
{
    isNavHideflage=!isNavHideflage;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
    [self.navigationController setNavigationBarHidden:isNavHideflage animated:TRUE];
    [self.navigationController setToolbarHidden:isNavHideflage animated:TRUE];
    [UIView commitAnimations];
    
}

- (id)init{
	self = [super init];
	if (self) {
     
        // add code here
}
	return self;
}


-(void)back:(id)sender{
    mBook.isPaginating = RJ_PAGINATING_STATE_IDLE; // 尽早使进行中的分页进程结束
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIView* aView = [navBar.subviews objectAtIndex:0];
    aView.hidden = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:TRUE];
    [self.navigationController setToolbarHidden:YES animated:TRUE];

    [self.navigationController popViewControllerAnimated:YES];
}

//添加书签
-(void) doBookmark
{
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    //读取旧的书签
    NSMutableArray *ChatperArray = nil;
    NSMutableArray *PageNumArray = nil;
    NSMutableArray *BookTimeArray = nil;
    NSMutableArray *OffsetArray = nil; // 支持字体变换
    NSMutableArray *fontIndexArray = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]])
    {
        ChatperArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]];
        PageNumArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]];
        BookTimeArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_booktime.plist"]]];
        OffsetArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_offset.plist"]]];
        fontIndexArray = [NSMutableArray arrayWithContentsOfFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_fontindex.plist"]]];
    }
    else{
        ChatperArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        PageNumArray = [[[NSMutableArray alloc] initWithCapacity:1]  autorelease];
        BookTimeArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        OffsetArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];
        fontIndexArray = [[[NSMutableArray alloc] initWithCapacity:1] autorelease];        
    }
    //判断是否已添加此标签 -> 支持字体变换 目前只有offset可唯一区分,故改为使用offset判断
//    for(NSUInteger i=0;i<[PageNumArray count];i++)
//    {
//        if([[PageNumArray objectAtIndex:i] integerValue] == pageIndex)
//        {
//            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"view.bookmark.alert.title", nil) message:NSLocalizedString(@"view.bookmark.alert.desc.marked", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"view.bookmark.alert.button.ok", nil) otherButtonTitles:nil];
//            [alertView show];
//            [alertView release];
//            return;
//        }
//    }
    unsigned long long offset = [mBook offsetWithPage:pageIndex];
    for(NSUInteger i=0;i<[OffsetArray count];i++)
    {
        if([[OffsetArray objectAtIndex:i] integerValue] == offset)
        {
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"view.bookmark.alert.title", nil) message:NSLocalizedString(@"view.bookmark.alert.desc.marked", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"view.bookmark.alert.button.ok", nil) otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            return;
        }
    }
    
    //添加新的书签
    [PageNumArray addObject:[NSString stringWithFormat:@"%d",pageIndex]];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd hh:mm a"];
    [BookTimeArray addObject: [fmt stringFromDate:[NSDate date]]];
    [fmt release];
    [OffsetArray addObject:[NSString stringWithFormat:@"%lld",offset]];
    [fontIndexArray addObject:[NSString stringWithFormat:@"%d", bookLabel.textFontSizeIndex]];
    //得到当前章节名称
    NSString* chapterName = nil;
    unsigned long long fileOffset = [mBook offsetWithPage:pageIndex];
    NSUInteger currentChapter = 0;
    NSUInteger fileSize = 0;
    for(;currentChapter<[singleBook.pageSize count];currentChapter++)
    {
        if(fileOffset >= fileSize && fileOffset < (fileSize + [[singleBook.pageSize objectAtIndex:currentChapter] integerValue]))
        {
               break;
        }
    }
    if(currentChapter >= [singleBook.pageSize count])
    {
        currentChapter = 0;
    }
    chapterName = [singleBook.pages objectAtIndex:currentChapter];
    [ChatperArray addObject:chapterName];
    //保存书签
    [ChatperArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_chatper.plist"]]  atomically:YES];
    [PageNumArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_pagenum.plist"]]  atomically:YES];
    [BookTimeArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_booktime.plist"]]  atomically:YES];
    [OffsetArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_offset.plist"]] atomically:YES];
    [fontIndexArray writeToFile:[Path stringByAppendingPathComponent:[singleBook.name stringByAppendingString:@"_fontindex.plist"]] atomically:YES];
    
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"view.bookmark.alert.title", nil) message:NSLocalizedString(@"view.bookmark.alert.desc.marked.ok", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"view.bookmark.alert.button.ok", nil) otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    return;
}

- (void)viewDidLoad {
    
    [self showCurrentPage:AllPage];
    // 读取设置
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSUInteger textColorIndex = [saveDefaults integerForKey:kReaderSettingTextColorIndex];
    NSUInteger textFontSizeIndex = [saveDefaults integerForKey:kReaderSettingTextFontSizeIndex];
    
    isShowIndex = NO;
    
    currentLight = [UIScreen mainScreen].brightness;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barStyle = UIBarStyleBlackTranslucent;
     UIView* aView = [navBar.subviews objectAtIndex:0];
    aView.hidden = NO;
    
        
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] init];
    leftBarButtonItem.title = NSLocalizedString(@"nav.back", nil);
    leftBarButtonItem.target = self;
    leftBarButtonItem.action = @selector(back:);
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    [leftBarButtonItem release];
        
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(doBookmark)];
    rightItem.enabled = NO; // 目前书签添加基于offset记录, 所以需要监测分页的完成状态. 直到分页完成才打开
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
    UIToolbar* toolBar = self.navigationController.toolbar;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    
    //为toolbar增加按钮
//    UIBarButtonItem *one = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play-last1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doPre)] autorelease];
    UIBarButtonItem *one = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"dojump.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doJumpTo)] autorelease]; // ahming 滑动条点击跳转时显示到中间
    UIBarButtonItem *two = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"color.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doFontColor)] autorelease];
    UIBarButtonItem *three = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"light.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doLightLevel)] autorelease];
//    UIBarButtonItem *four = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"play-next.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doNext)] autorelease];
    UIBarButtonItem *four = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fontsize.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doFontSize)] autorelease]; // 更改字体大小
    UIBarButtonItem *five = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"index.png"] style:UIBarButtonItemStylePlain target:self action:@selector(doIndex)] autorelease];
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    [one setEnabled:NO]; // 跳转和改文字大小需要等待分页结束才允许使用
    [four setEnabled:NO];
    
    [self setToolbarItems: [NSArray arrayWithObjects: one,flexItem, two,flexItem, three,flexItem, four,flexItem, five, nil]];
    [self.navigationController.toolbar sizeToFit];


    
    isNavHideflage=YES;
    [self.navigationController setNavigationBarHidden:isNavHideflage animated:TRUE];
    [self.navigationController setToolbarHidden:isNavHideflage animated:TRUE];

	
	self.view.backgroundColor = [UIColor clearColor]; // clearColor ahming test whiteColor -> 需要修改更多. 确保点击太阳转换黑白字体颜色时正常
	
	pageIndex = 1;
    pageIndexBeforeJump =1;
	headView = nil;

	bookLabel = [[PageView alloc] initWithFrame:CGRectMake(0, 0, 320,
                                                           myHight - 20 // 这个20应对应状态栏,PageView中的height不应该再引用myHight
                                                           - RJ_UI_BOOK_SLIDER_HEIGHT_ON_BOTTOM
                                                           - RJ_UI_BOOK_VIEW_ADS_HEIGHT_ON_BOTTOM
                                                           )]; // ahming-marks-page // 为什么最初 y -20 -> test y 0 -> OK
    [bookLabel updateTextColorByIndex:textColorIndex];
    [bookLabel updateTextFontSizeByIndex:textFontSizeIndex];
	[self.view addSubview:bookLabel];
    
	mBook = [[KDBook alloc]initWithBook:bookIndex];
    mBook.delegate = self;
    
    // ahming marks: 猜测, 下面的pageSize与textFont必须保证与PageView中init处的设置相同, 否则会引起页面内容与实际页数不同步?
    // --> 基础可验证的确如此: 对应下面 bookLabel.frame.size.height-20, 若在 PageView 中不相同, 如使用 bookLabel.frame.size.height不减去20的话, 则从第7部书可验证. 此时第7部书的不同页数的高度参差不齐, 且可留意第2页最后一行, "容纳的人数20 - 50人", 20和-50分在两页, 且20只显示部分, 其他部分被屏幕外部遮住了. 若 PageView 处也使用 bookLabel.frame.size.height-20, 则第7部书不同页数的高度都相同, 没有参差. 不过奇怪的系此时, "容纳的人数20 - 50人"这句, 20所在的一行显示缺失了. 可知这句有特殊性.
    // 那么, 后期应该优化一下, 确保这两片的设置相同.
	mBook.pageSize = CGSizeMake(bookLabel.frame.size.width-20, bookLabel.frame.size.height-20);//bookLabel.frame.size; // ahming-marks-page
	mBook.textFont = [UIFont systemFontOfSize:[bookLabel getTextFontSize]];//bookLabel.font;
    
    // 屏幕中部显示跳转控制条
	UIView *jumptoview = [[UIView alloc] initWithFrame:CGRectMake(10,
                                                                  (myHight - 20 // 20对应状态栏
                                                                   - 85         // 高度
                                                                   )/2, 300, 85)]; // 100 -> 居中
    jumptoview.hidden = YES;
    [jumptoview setBackgroundColor:[UIColor blackColor]];
    
    jumpToView = [jumptoview retain];
    [jumptoview release];
    
    // OK & Cancel button
    //UIImage *image1 = [UIImage imageNamed:@"bookmark.png"];
    //UIImage *image2 = [UIImage imageNamed:@"color.png"];
    
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setFrame:CGRectMake(170, 55, 60, 20)];
        //[b setBackgroundImage:image1 forState:UIControlStateNormal];
        //[b setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [b setTitle:NSLocalizedString(@"button.ok", nil) forState:UIControlStateNormal];
        //[b setTitle:NSLocalizedString(@"button.ok", nil) forState:UIControlStateHighlighted];
        [b addTarget:self action:@selector(okJumpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [jumptoview addSubview:b];
        okJumpButton = [b retain];
    }    
    {
        UIButton *b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setFrame:CGRectMake(70, 55, 60, 20)];
        //[b setBackgroundImage:image1 forState:UIControlStateNormal];
        //[b setBackgroundImage:image2 forState:UIControlStateHighlighted];
        [b setTitle:NSLocalizedString(@"button.cancel", nil) forState:UIControlStateNormal];
        //[b setTitle:NSLocalizedString(@"button.cancel", nil) forState:UIControlStateHighlighted];
        [b addTarget:self action:@selector(cancelJumpButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [jumptoview addSubview:b];
        cancelJumpButton = [b retain];
    }
    
	//UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(10, myHight-30, 300, 20)];//yu mark 更改滑动条，使其居中 -40
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 20, 300, 20)]; // as jumpToView subview
    
	slider.maximumValue = 300;
	slider.minimumValue = 1;
	slider.value = 1;
	slider.alpha = 0.4;
	[slider addTarget:self action:@selector(sliderEvent) forControlEvents:UIControlEventValueChanged];
	bookSlider = [slider retain];
	[jumpToView addSubview:slider]; //[self.view addSubview:slider];
    [self.view addSubview:jumpToView];
	[slider release];
    
    [self performSelector:@selector(showPage) withObject:self afterDelay:0.25];
    
    
    
}



//toolbar的响应事件

-(void) okJumpButtonAction:(id) sender
{
    if (bookSlider.value != pageIndexBeforeJump) {
        [self savePlace:bookSlider.value];
    }
    [jumpToView setHidden:YES]; // 将要添加动画
}
-(void) cancelJumpButtonAction:(id) sender
{
    if (pageIndex != pageIndexBeforeJump) {
        pageIndex = pageIndexBeforeJump;
        bookSlider.value = pageIndex;
        bookLabel.text = [mBook stringWithPage:pageIndex];
        [self savePlace:pageIndex];
        [self showCurrentPage:AllPage];        
    }
    [jumpToView setHidden:YES]; // 将要添加动画
}
-(void) doJumpTo // 跳转
{
    //[jumpToView setHidden:NO]; // 将要添加动画
    [self showHideJumpView];    
}
-(void) showHideJumpView
{
    BOOL isJumpToViewShown = ![jumpToView isHidden];
    if (isJumpToViewShown) {
        // 此时当取消跳转
        if (pageIndex != pageIndexBeforeJump) {
            pageIndex = pageIndexBeforeJump;
            bookSlider.value = pageIndex;
            bookLabel.text = [mBook stringWithPage:pageIndex];
            [self savePlace:pageIndex];
            [self showCurrentPage:AllPage];
        }
    }
    [jumpToView setHidden:isJumpToViewShown]; // 将要添加动画
}

-(void) doPre
{
  
    if ( pageIndex > 1) {
        --pageIndex;
        bookSlider.value = pageIndex;
        NSString* string = [mBook stringWithPage:pageIndex];
        bookLabel.text = string;
        [self exchangeAnimate:1];
        [self savePlace:pageIndex];
       [self showCurrentPage:AllPage];
        return ;
    }
 
}
-(void) doNext
{
  
    if ( pageIndex < bookSlider.maximumValue) {
        ++pageIndex;
        bookSlider.value = pageIndex;
        NSString* string = [mBook stringWithPage:pageIndex];
        bookLabel.text = string;
        [self exchangeAnimate:0];
        [self savePlace:pageIndex];
        [self showCurrentPage:AllPage];
        return ;
    }
}
-(void) doFontColor
{
    NSUInteger resultColorIndex = [bookLabel changeColor];
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setInteger:resultColorIndex forKey:kReaderSettingTextColorIndex];
}
-(void) doFontSize // 循环切换文字大小
{
    // 此处要更新 MODEL KDBook的分页, 调整页数等
    // 其他细节: 分页时基于首页首行还是当前页当前行? 怎样重新载入视图?
    // 并需要确保之前的分页已结束, 例如防止刚进入书本后立即点击字体切换出现问题
    CGFloat previousFontSize = [bookLabel getTextFontSize];
    mBook.textFont = [UIFont systemFontOfSize:[bookLabel getTextFontSizeForTestChange]]; // only try in advance
    if ([mBook pageArUpdate]) {
        
        // 更新控件
        [self.navigationController.toolbar.items[0] setEnabled:NO];
        [self.navigationController.toolbar.items[6] setEnabled:NO];
        [self.navigationItem.rightBarButtonItem setEnabled:NO];
        
        NSUInteger resultFontSizeIndex = [bookLabel changeFontSize];
        NSUserDefaults *saveDefault = [NSUserDefaults standardUserDefaults];
        [saveDefault setInteger:resultFontSizeIndex forKey:kReaderSettingTextFontSizeIndex];
    } else {
        mBook.textFont = [UIFont systemFontOfSize:previousFontSize];
        
        // 给出更友好的提示信息 (采取提示信息而不是直接停止前次分页的原因, 系避免更复杂的修改)
        // --> 后面优化区分初次进入书本点击改字体和正常情况下连续点击切换字体(加timer?)
        // --> 使用按钮setEnable后不需要了
//        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"view.bookmark.alert.title", nil) message:NSLocalizedString(@"toolbar.btn.fontsize.hit.waiting", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"view.bookmark.alert.button.ok", nil) otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
    }

}

-(void) doLightLevel //调节屏幕亮度
{
    currentLight = currentLight -0.1;
    if(currentLight < 0.3)
    {
        currentLight = 1.0;
    }
    [[UIScreen mainScreen] setBrightness: currentLight];
}

-(void) doIndex
{
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    unsigned long long fileOffset = [mBook offsetWithPage:pageIndex];
    NSUInteger currentChapter = 0;
    NSUInteger fileSize = 0;
    for(;currentChapter<[singleBook.pageSize count];currentChapter++)
    {
        if(fileOffset > fileSize && fileOffset < (fileSize + [[singleBook.pageSize objectAtIndex:currentChapter] integerValue]))
        {
            break;
        }
    }

    RJBookIndexViewController *indexVC = [[RJBookIndexViewController alloc]init];
	indexVC.bookIndex = self.bookIndex;
    indexVC.chapterNum = currentChapter;
    indexVC.delegate = self;
    isShowIndex = YES;
	[self.navigationController pushViewController:indexVC animated:YES];
	[indexVC release];
}

- (void)willBack
{
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    isShowIndex = NO;
}

- (void)gotoPage:(NSUInteger) gotoPageNum
{
    if ( gotoPageNum < bookSlider.maximumValue) {
        pageIndex = gotoPageNum;
        bookSlider.value = pageIndex;
        NSString* string = [mBook stringWithPage:pageIndex];
        bookLabel.text = string;
        [self exchangeAnimate:0];
        [self savePlace:pageIndex];
        return ;
    }
}
- (void)gotoPageWithOffset:(unsigned long long) offset page:(NSUInteger) gotoPageNum fontindex:(NSUInteger) index; // 支持字体变换
{
    if (index == bookLabel.textFontSizeIndex) {
        [self gotoPage:gotoPageNum];
    } else {
        [self gotoPage:[mBook pageIndexWithOffset:offset]];
    }
}
- (void)gotoChapter:(NSUInteger) gotoChapterNum
{
    //根据章节得到页数，然后跳到此页
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    NSUInteger fileSize = 0;
    for(NSUInteger i=0;i<gotoChapterNum;i++)
    {
        fileSize += [[singleBook.pageSize objectAtIndex:i] integerValue];
    }

    NSUInteger tempPage = 1;
    unsigned long long fileOffset;
    for(;tempPage<bookSlider.maximumValue;tempPage++)
    {
        fileOffset = [mBook offsetWithPage:tempPage];
        if(fileOffset > fileSize)
        {
            tempPage--;
            break;
        }
    }
    [self gotoPage:tempPage];
}



- (void)dealloc {
	[headView release];
	[bookSlider release];
    [okJumpButton release];
    [cancelJumpButton release];
    [jumpToView release];
    
	mBook.delegate = nil;
	[mBook release];
	mBook = nil;
	[bookLabel release];
	
    [super dealloc];
}

-(void) showPage
{
    //从持久化存储读取上次阅读位置,跳到上次所看的页面
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    NSUInteger lastPage = [saveDefaults integerForKey:singleBook.name];
    if(lastPage == 0) lastPage = 1;
    pageIndex = lastPage;
    pageIndexBeforeJump = pageIndex;
    
    // 需要去掉下面第1页关于stringWithPage的特殊性, 与其他页一致, 因为: (1) stringWithPage中不需要区分第1页, 全部页统一一致
    // (2) stringWithPage含有 minEnoughStringLength 的更新, 改字体等时初次进入书本内容时需要保证更新
    //if(pageIndex > 1)
    {
        //pageIndex = lastPage; // 重复了
        bookSlider.value = pageIndex;
        NSString* string = [mBook stringWithPage:pageIndex];
        if(string)
        {
            bookLabel.text = string;
        }
        else
        {
            [self performSelector:@selector(showPage) withObject:self afterDelay:0.25];
        }
    }
}

- (void)firstPage:(NSString *)pageString{
    if( pageIndex > 1)
    {
        return;
    }
	if (pageString) {
		bookLabel.text = pageString;
	}
}

- (void)bookDidRead:(NSUInteger)size{
	bookSlider.maximumValue = size;
	bookSlider.value = pageIndex;
  }

- (void)showCurrentPage:(int)maxpage{
    
    AllPage=maxpage;
    currentPage =pageIndex;
     UILabel *pageShow = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    pageShow.font = [UIFont systemFontOfSize:16];
    pageShow.textColor = [UIColor whiteColor];
    pageShow.backgroundColor = [UIColor clearColor];
    pageShow.textAlignment = UITextAlignmentCenter;
    pageShow.text = [NSString stringWithFormat:@"%d/%d",currentPage,AllPage];
    self.navigationItem.titleView = pageShow;
    [pageShow release];
 }


- (NSUInteger)getPageIndex
{
    return pageIndex;
}

- (void)updateAfterUpdatePageWithPageIndex:(NSInteger) index
{
    if(index > -1) {
        pageIndex = index;
        [self savePlace:pageIndex];
        
        // 请注意, 此处目前没有更新新分页后的实际页内容. 目的系避免看起来不自然
    }
    
    // 更新控件
    [self.navigationController.toolbar.items[0] setEnabled:YES];
    [self.navigationController.toolbar.items[6] setEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
}

- (void)updatePageStringBeforeUpdate:(NSString *) pageString
{
    bookLabel.text = pageString;
    
    // 无需其他任何操作了, 例如不需要保存
}


@end
