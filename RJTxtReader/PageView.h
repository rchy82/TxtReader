

#import <UIKit/UIKit.h>


@interface PageView : UIView {
	NSString *text;
	UILabel *pageL;
    
    BOOL isWhiteColor; // ahming marks: 这个选项应该系全局的. 且需要持久化 -> 将不再使用此标志
    NSUInteger textColorIndex; // -> 顺便扩展一下, 支持更多的颜色
    NSArray *textColorSets; 
}
@property (nonatomic,retain) NSString *text;
@property (retain) NSArray *textColorSets;

-(NSUInteger) changeColor;
-(void) updateTextColorByIndex:(NSUInteger) index;

@end
