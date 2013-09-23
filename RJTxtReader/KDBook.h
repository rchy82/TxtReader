

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "RJBookData.h"
@protocol KDBookDelegate

- (void)firstPage:(NSString *)pageString;
//遍历完文档后
- (void)bookDidRead:(NSUInteger)size;

//yu mark 增加显示进入书本显示页码
-(void)showCurrentPage:(int)mxpage;

@end


@interface KDBook : NSObject {
	CGSize     pageSize; //页面大小（与分页有关）
	UIFont    *textFont; //字体大小（与分页有关）
    NSInteger bookIndex;
    NSInteger bookPageIndex;
    NSString  *bookName; //需要把所有文件合并在一起
	NSMutableArray   *pageIndexArray; //保存每页的下标（文件的偏移量-分页）
	NSThread  *thread;
    int allPage; //总页数
	
	unsigned long long bookSize;
	
	id<KDBookDelegate>  delegate;
}

@property (nonatomic, readwrite) NSInteger  bookIndex;
@property (nonatomic, retain) UIFont    *textFont;
@property (nonatomic, assign) CGSize     pageSize;
@property (nonatomic, assign) id<KDBookDelegate>  delegate;
@property (nonatomic, readonly) unsigned long long bookSize;
@property (nonatomic) BOOL isPaginating; // YES表示当前分页线程进行中, 在按"返回"回到书本列表时,需要置NO使该线程迟早结束

//返回指定页的字符串；
- (NSString *)stringWithPage:(NSUInteger)pageIndex;
- (unsigned long long)offsetWithPage:(NSUInteger)pageIndex;
- (id)initWithBook:(NSInteger) newBookIndex;
- (void) createBook;
- (void) getAllPage;

@end
