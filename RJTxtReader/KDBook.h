

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "RJBookData.h"

typedef enum {
    RJ_PAGINATING_STATE_IDLE = 0,
    RJ_PAGINATING_STATE_FIRST_RUNNING,
    RJ_PAGINATING_STATE_UPDATE_RUNNING
} RJPaginatingState;

@protocol KDBookDelegate

- (void)firstPage:(NSString *)pageString;
//遍历完文档后
- (void)bookDidRead:(NSUInteger)size;

//yu mark 增加显示进入书本显示页码
-(void)showCurrentPage:(int)mxpage;

- (NSUInteger)getPageIndex; // 个人对这函数命名, 意图和此delegate取保留意见
- (void)updateAfterUpdatePageWithPageIndex:(NSInteger) index; // 更新控件状态等
- (void)updatePageStringBeforeUpdate:(NSString *) pageString; // 使更自然, 把改字体后的当前页保证填满. 通常只为照顾从最大字体变换最小字体时

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
    
    unsigned long long offsetBeforeUpdatePage;
    unsigned long long minEnoughStringLength; // 原两页的内容能保证新分页后至少能填满当前要预先读取来显示的页
	
	unsigned long long bookSize;
	
	id<KDBookDelegate>  delegate;
}

@property (nonatomic, readwrite) NSInteger  bookIndex;
@property (nonatomic, retain) UIFont    *textFont;
@property (nonatomic, assign) CGSize     pageSize;
@property (nonatomic, assign) id<KDBookDelegate>  delegate;
@property (nonatomic, readonly) unsigned long long bookSize;
@property (nonatomic) RJPaginatingState isPaginating; // 非IDLE表示当前分页线程进行中, 在按"返回"回书本列表时,需要强制IDLE使该线程尽早结束

//返回指定页的字符串；
- (NSString *)stringWithPage:(NSUInteger)pageIndex;
- (unsigned long long)offsetWithPage:(NSUInteger)pageIndex;
- (id)initWithBook:(NSInteger) newBookIndex;
- (void) createBook;
- (void) getAllPage;

- (BOOL)pageArUpdate;
- (NSUInteger)pageIndexAfterUpdatePage;
//- (NSString *)minEnoughStringFullfillWholePage:(NSUInteger) pageIndex indexArray:(NSMutableArray *) array;
- (NSString *)minEnoughStringFullfillWholePage;
- (NSUInteger)pageIndexWithOffset:(unsigned long long)offset;

@end
