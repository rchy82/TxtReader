//
//  KDBook.m
//  Gether
//
//  Created by lucky on 12-8-9.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "KDBook.h"


@implementation KDBook
@synthesize bookIndex;
@synthesize textFont;
@synthesize pageSize;
@synthesize delegate;
@synthesize bookSize;
@synthesize isPaginating; // 非IDLE表示当前分页线程进行中, 在按"返回"回书本列表时,需要强制IDLE使该线程尽早结束

- (NSString *)filePath:(NSString *)fileName{
	if (fileName == nil) {
		return nil;
	}

	return fileName;
}

- (NSFileHandle *)handleWithFile:(NSString *)fileName {
    if (fileName == nil) {
		//  print : wrong file name;
		return nil;
	}
	NSString *path = [self filePath:fileName];
	if (path == nil) {
		//  print : can not find the file
		return nil;
	}
	return [NSFileHandle fileHandleForReadingAtPath:path];	
}

- (unsigned long long)fileLengthWithFile:(NSString *)fileName{
	if (fileName == nil) {
		return (0);
	}
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *path = [self filePath:fileName];
	NSError *error;
	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
	if (!fileAttributes) {
		NSLog(@"%@",error);
		return (0);
	}
	return [[fileAttributes objectForKey:NSFileSize] unsignedLongLongValue];
}


//偏移量调整（防止英文字符 一个单词被分开）
- (unsigned long long)fixOffserWith:(NSFileHandle *)handle{
	unsigned long long offset = [handle offsetInFile];
	if (offset == 0) {
		return (0);
	}
	NSData *oData = [handle readDataOfLength:1];
	if (oData) {
		NSString *jStr = [[NSString alloc]initWithData:oData encoding:NSUTF8StringEncoding];
		if (jStr) {
			char *oCh = (char *)[oData bytes];
			while  ((*oCh >= 65 && *oCh <= 90) || (*oCh >= 97 && *oCh <= 122)) {								
				[handle seekToFileOffset:--offset];									
				NSData *jData = [handle readDataOfLength:1];
				NSString *kStr = [[NSString alloc]initWithData:jData encoding:NSUTF8StringEncoding];
				if (kStr == nil || offset == 0) {
					[kStr release];
					break;
				}
				[kStr release];
				oCh = (char *)[jData bytes];								
			}
			offset++;								
		}
		[jStr release];
	}
	return offset;
}

- (void)showFirstPage{
    
   
	if (delegate && [(NSObject *)delegate respondsToSelector:@selector(firstPage:)]) {
        RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
//        NSString* bookName = singleBook.bookFile;
		NSFileHandle * handle = [self handleWithFile:singleBook.bookFile];
		NSData *data = [handle readDataOfLength:[[pageIndexArray objectAtIndex:0] unsignedLongLongValue]];
		NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		if (string) {
			[delegate firstPage:string];
		}	
	}
}

- (void)bookDidRead:(NSUInteger)size{
	if (delegate && [(NSObject *)delegate respondsToSelector:@selector(bookDidRead:)]) {
		[delegate bookDidRead:size];
	}
}

- (void)showCurrentPage:(int)maxpage{
	if (delegate && [(NSObject *)delegate respondsToSelector:@selector(showCurrentPage:)]) {
		[delegate showCurrentPage:maxpage];
	}
    
}

-(NSUInteger)getPageIndex
{
    if (delegate && [(NSObject *)delegate respondsToSelector:@selector(getPageIndex)]) {
		return [delegate getPageIndex];
	}
    
    return 1; //0; // 还是1更好呢?
}

- (void)updateAfterUpdatePageWithPageIndex:(NSInteger) index
{
    if (delegate && [(NSObject *)delegate respondsToSelector:@selector(updateAfterUpdatePageWithPageIndex:)]) {
		[delegate updateAfterUpdatePageWithPageIndex:index];
	}
}

- (void)updatePageStringBeforeUpdate:(NSString *) pageString
{
    if (delegate && [(NSObject *)delegate respondsToSelector:@selector(updatePageStringBeforeUpdate:)]) {
		[delegate updatePageStringBeforeUpdate:pageString];
	}
}

- (unsigned long long)indexOfPage:(NSFileHandle *)handle textFont:(UIFont *)font{
	unsigned long long offset = [handle offsetInFile];
	unsigned long long fileSize = bookSize;
	NSUInteger MaxWidth = pageSize.width, MaxHeigth = pageSize.height;
	
	BOOL isEndOfFile = NO;
	NSUInteger length = 100;
	NSMutableString *labelStr = [[NSMutableString alloc] init];	
	do{		
		for (int j=0; j<3; j++) {
			if ((offset+length+j) > fileSize) {
				offset = fileSize;
				isEndOfFile = YES;
				break ;
			}
			[handle seekToFileOffset:offset];
			NSData *data = [handle readDataOfLength:j+length];
			if (data) {
				NSString *iStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
				if (iStr ) {					
					NSString *oStr = [NSString stringWithFormat:@"%@%@",labelStr,iStr];
					
					CGSize labelSize=[oStr sizeWithFont:font
									  constrainedToSize:CGSizeMake(MaxWidth,1000) 
										  lineBreakMode:UILineBreakModeWordWrap];
					if (labelSize.height-MaxHeigth > 0 && length != 1) {
						if (length <= 5) {
							length = 1;
						}else {
							length = length/(2);
						}
					}else if (labelSize.height > MaxHeigth && length == 1) {
						offset = [handle offsetInFile]-length-j;
						[handle seekToFileOffset:offset];						
						offset = [self fixOffserWith:handle];
						isEndOfFile = YES;
					}else if(labelSize.height <= MaxHeigth ) {
						[labelStr appendString:iStr];
						offset = j+length+offset;
					}					
					[iStr release];
					break ;
				}
				[iStr release];
			}
		}
		if (offset >= fileSize) {
			isEndOfFile = YES;
		}		
	}while (!isEndOfFile);
	//NSLog(@"offset :%d",offset);
	[labelStr release];
	return offset;
}


#pragma mark lll

- (NSString *)stringWithPage:(NSUInteger)pageIndex{
    NSUInteger count = [pageIndexArray count];
	if (pageIndex > count) {
		return nil;
	}
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
//    NSString* bookName = singleBook.bookFile;
	NSFileHandle *handle = [self handleWithFile:singleBook.bookFile];
	unsigned long long offset = 0;
	if (pageIndex > 1) {
		offset = [[pageIndexArray objectAtIndex:pageIndex-2]unsignedLongLongValue];
	}
    
    // 此处记录适合
    offsetBeforeUpdatePage = offset;
        
	[handle seekToFileOffset:offset];
	unsigned long long length = [[pageIndexArray objectAtIndex:pageIndex-1]unsignedLongLongValue]-offset;
    
    // 值等于当前页和下一页的两页总长
    if (pageIndex == count) {
        minEnoughStringLength = length;
    } else if (pageIndex < count) {
        minEnoughStringLength = [[pageIndexArray objectAtIndex:pageIndex]unsignedLongLongValue] - offset;
    }
    
    
	NSData *data  = [handle readDataOfLength:length];
	NSString *labelText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	if (labelText == nil) {
		return nil;
	}

    return labelText;
}

- (unsigned long long)offsetWithPage:(NSUInteger)pageIndex
{
    if (pageIndex > [pageIndexArray count]) {
		return 0;
	}

	unsigned long long offset = 0;
	if (pageIndex > 1) {
		offset = [[pageIndexArray objectAtIndex:pageIndex-2]unsignedLongLongValue];
	}

    return offset;
}

- (NSUInteger)pageIndexAfterUpdatePage
{
    if (offsetBeforeUpdatePage == 0) // 第1页具特殊性
        return 1;
    
	NSUInteger resultIndex = 1; //fixed from 2;
    unsigned long long offset = 0;
	
	offset = [[pageIndexArray objectAtIndex:0] unsignedLongLongValue];
    if (offsetBeforeUpdatePage > offset) {        
        do {
            resultIndex++;
            offset = [[pageIndexArray objectAtIndex:(resultIndex - 2)] unsignedLongLongValue];            
        } while (offsetBeforeUpdatePage > offset);
        
        resultIndex--;
    }
    
    return resultIndex ; //- 1;
}

- (NSUInteger)pageIndexWithOffset:(unsigned long long)offset
{
    if (offset == 0) // 第1页具特殊性
        return 1;
    
	NSUInteger resultIndex = 1; //fixed from 2;
    unsigned long long offsetTemp = 0;
	
	offsetTemp = [[pageIndexArray objectAtIndex:0] unsignedLongLongValue];
    if (offset > offsetTemp) {
        do {
            resultIndex++;
            offsetTemp = [[pageIndexArray objectAtIndex:(resultIndex - 2)] unsignedLongLongValue];
        } while (offset > offsetTemp);
        
        resultIndex--;
    }
    
    return resultIndex ;    
}

- (NSString *)minEnoughStringFullfillWholePage
{    
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
	NSFileHandle *handle = [self handleWithFile:singleBook.bookFile];

	[handle seekToFileOffset:offsetBeforeUpdatePage];

    //unsigned long long length = 906; // !!!!! 结果表明, 这个值不能任意! 必须保证, 它截取出来的内容能被 NSUTF8StringEncoding 正常解码读取, 否则, 下面的labelText的结果为空
    
	NSData *data  = [handle readDataOfLength:minEnoughStringLength]; //length
    NSString *labelText = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	if (labelText == nil) {
		return nil;
	}
    
    return labelText;
}

-(void)bookIndexx{
  
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
//    NSString* bookName = singleBook.bookFile;
	NSFileHandle *handle = [self handleWithFile:singleBook.bookFile];
	NSUInteger count = [pageIndexArray count];
    
	unsigned long long index = [[pageIndexArray objectAtIndex:count-1] unsignedLongLongValue];
    
    //isPaginating = RJ_PAGINATING_STATE_FIRST_RUNNING; // 分页开始 放此处OK?还是需要放到外面?亦或类似c的volatile? -> 放外面测试 OK
	while (index < bookSize && isPaginating != RJ_PAGINATING_STATE_IDLE) { // 必须使用黑名单比较
		[handle seekToFileOffset:index];
		index = [self indexOfPage:handle textFont:textFont];
		[pageIndexArray addObject:[NSNumber numberWithUnsignedLongLong:index]];
		//NSLog(@"--index:%lld",index);
  }
    isPaginating = RJ_PAGINATING_STATE_IDLE; // 分页正常结束
    //NSLog(@"Instantly over, OK!");
    
    [self updateAfterUpdatePageWithPageIndex:-1]; // 更新控件状态等 -1表示不关心此参数 建议在下面getAllPage之前
    
    //yu mark 未通过测试，暂时去除 -> 
    [self getAllPage];
	[self bookDidRead:[pageIndexArray count]];
	[pool release];
}


- (void)pageAr{
 
	if (bookIndex < 0) {
		return ;
	}
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
//    NSString* bookName = singleBook.bookFile;
	bookSize = [self fileLengthWithFile:singleBook.bookFile];
	NSFileHandle *handle = [self handleWithFile:singleBook.bookFile];
	unsigned long long index = 0;	
	pageIndexArray = [[NSMutableArray alloc] init];
	for (int i=0; i<3; i++)  {		
		index = [self indexOfPage:handle textFont:textFont];
		[pageIndexArray addObject:[NSNumber numberWithUnsignedLongLong:index]];
		[handle seekToFileOffset:index];		
	}
    
	[self showFirstPage];
	
	//NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	thread = [[NSThread alloc]initWithTarget:self selector:@selector(bookIndexx) object:nil];
    isPaginating = RJ_PAGINATING_STATE_FIRST_RUNNING; // 分页开始 -> OK
	[thread start];
	//[pool release];
	//[NSThread detachNewThreadSelector:@selector(bookIndex) toTarget:self withObject:nil];
}

-(void)bookIndexUpdate{
    
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];
    //    NSString* bookName = singleBook.bookFile;
	NSFileHandle *handle = [self handleWithFile:singleBook.bookFile];
	NSUInteger count = [pageIndexArray count];
    
	unsigned long long index = [[pageIndexArray objectAtIndex:count-1] unsignedLongLongValue];
    
    //isPaginating = RJ_PAGINATING_STATE_UPDATE_RUNNING; // 分页开始 放此处OK?还是需要放到外面?亦或类似c的volatile? -> 放外面测试 OK
	while (index < bookSize && isPaginating != RJ_PAGINATING_STATE_IDLE) { // 必须使用黑名单比较
		[handle seekToFileOffset:index];
		index = [self indexOfPage:handle textFont:textFont];
		[pageIndexArray addObject:[NSNumber numberWithUnsignedLongLong:index]];
		//NSLog(@"--index:%lld",index);
    }
    isPaginating = RJ_PAGINATING_STATE_IDLE; // 分页正常结束
    //NSLog(@"Instantly over, OK!");
    
    [self updateAfterUpdatePageWithPageIndex:[self pageIndexAfterUpdatePage]]; // 更新控件状态等 建议在下面getAllPage之前
    
    //yu mark 未通过测试，暂时去除 ->
    [self getAllPage];    
	[self bookDidRead:[pageIndexArray count]]; // 此处更新bookSlider位置, 所以待确认更新 -> 必须在上一句之后
	[pool release];
}

- (BOOL)pageArUpdate{
    if (isPaginating != RJ_PAGINATING_STATE_IDLE) {
        return NO; // 上一次分页未完成, 阻止
    }
    
	if (bookIndex < 0) {
		return NO;
	}
    RJSingleBook* singleBook = [[RJBookData sharedRJBookData].books objectAtIndex:bookIndex];

	//bookSize = [self fileLengthWithFile:singleBook.bookFile]; // 可优化去掉? -> 去掉
	NSFileHandle *handle = [self handleWithFile:singleBook.bookFile];
	unsigned long long index = 0;
    
    // 需要记好当前的offset, 以备使用, 必须在更新pageIndexArray之前
    //if (![self getFontSizeUpdateSaveStatus]) {
    //    offsetBeforeUpdatePage = [self offsetWithPage:[self getPageIndex]];
    //}
    // --> 目前此处有误, 可能系这个此刻访问 offsetWithPage 使用了新的pageIndexArray等而非旧的
    // offsetBeforeUpdatePage的实质系上一次的offset记录 能否在上次更新时就记录好, 而此处根本不需要改变?
    // --> 在 stringWithPage 处记录, 适合
    
    // 简单处理, 预读足够最小字体满页的内容更新到屏幕, 注意边界情况, 例如读取的最后时不需要满页
    [self updatePageStringBeforeUpdate:[self minEnoughStringFullfillWholePage]];

    [pageIndexArray release];
    pageIndexArray = nil;
	pageIndexArray = [[NSMutableArray alloc] init];
	for (int i=0; i<3; i++)  {
		index = [self indexOfPage:handle textFont:textFont];
		[pageIndexArray addObject:[NSNumber numberWithUnsignedLongLong:index]];
		[handle seekToFileOffset:index];
	}
    
	//[self showFirstPage]; // 不要返回首页, 但此处更新页数, 所以要相应补上操作, 必须提前显示目前的页
    // 确保更新好当前页数等 相关api除了类似的firstPage, 还有 KDBOoKViewController:
    // - (void)gotoPage:(NSUInteger) gotoPageNum
    // pageIndex -> 当前页数
    // 目前工作要计算出当前页在新的分页中的页数. 计算的时机在此处可能适合(原因见下), 可使用当前的offset值和其他相关数据.
    // (1)如果直接使用当前页内容, 从小字体到大字体, 显得较自然, 不足系最后一行可能只显示部分, 不过若从最大字体变到小字体, 直接会不满页. 需要优化
    // (2)如果不直接使用当前页内容, 要延后, 直到分页到包含当前页的位置或全部分页结束, 但这样会觉得不自然
    // 一个优化的分页策略系按目前首行作为新分页的当前页首行, 向前整页整页分, 则只考虑首页不满页即可.
    // --> 不是等宽字体, 情况复杂, 基本无法预先计算当前页在新分页的页数, 需要等待直到遍历到当前页内容.
    // 所以目前确定了使用 offsetBeforeUpdatePage 和 minEnoughStringLength 处的内容
    	
    // 因为update分页与初次分页有所区别, 如设置当前页数不同, 需要调整, 所以把bookIndexx单独出来 
	thread = [[NSThread alloc]initWithTarget:self selector:@selector(bookIndexUpdate) object:nil];
    isPaginating = RJ_PAGINATING_STATE_UPDATE_RUNNING; // 分页开始 -> OK
	[thread start];
    
    return YES;
}

#pragma mark NSObject FUNCTION


- (id)init{
	self = [super init];
	if (self) {
		//add your code here
		pageIndexArray = nil;
		bookIndex = -1;
        bookPageIndex = 0;
		textFont = [[UIFont systemFontOfSize:16] retain];
	    pageSize = CGSizeMake(320, 460);
        
        isPaginating = RJ_PAGINATING_STATE_IDLE;
        offsetBeforeUpdatePage = 0;
        minEnoughStringLength = 0;
	}
	return self;
}

- (id)initWithBook:(NSInteger)newBookIndex{
	self = [self init];
  
	if (self) {
		bookIndex = newBookIndex;
		[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(pageAr) userInfo:nil repeats:NO];
	}
	
	return self;
}

- (void) createBook
{
    
}

//yu mark 获取页码总数有问题，未通过测试，暂时去除
-(void)getAllPage{
    allPage=[pageIndexArray count];
    [self showCurrentPage:allPage];
    NSLog(@"--------------------%d",allPage);
}

- (void)dealloc{
	[thread release];
	[pageIndexArray release];
	[textFont release];
	[super dealloc];
}

- (void)setDelegate:(id <KDBookDelegate>)dele{
	delegate = dele;
	if (delegate == nil) {
		[thread cancel];		
		thread = nil;
	}
}

@end
