

#import "ReaderConstants.h"
#import "PageView.h"


@implementation PageView
@synthesize text;
//@synthesize textColorSets; // 不需要外部访问

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		text = nil;
        isWhiteColor = NO;
        
        textFontSizeIndex = 0;
        textFontSizeArray = [@[[NSNumber numberWithFloat:18.0],
                               [NSNumber numberWithFloat:20.0],
                               [NSNumber numberWithFloat:16.0]] retain];
        
        // ahming 扩充可选颜色
        textColorIndex = 0;
        NSDictionary *colorSet1 = @{@"font-color": [UIColor blackColor], @"backgroud-color": [UIColor whiteColor]};
        NSDictionary *colorSet2 = @{@"font-color": [UIColor whiteColor], @"backgroud-color": [UIColor blackColor]};
        // 如果要支持更多颜色, 在此添加 colorSet03, 04, ...
        //NSDictionary *colorSet3 = @{@"font-color": [UIColor whiteColor], @"backgroud-color": [UIColor blueColor]};
        textColorSets = [@[colorSet1, colorSet2] retain];
        //NSLog(@"count is %d", [textColorSets count]);
        
        self.backgroundColor = [textColorSets[textColorIndex] objectForKey:@"backgroud-color"]; // [UIColor whiteColor];
        
        pageL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-20, self.frame.size.height-20)]; // ahming-marks-page     myHight-20 应该指减去状态栏的高度, x=15和width-20目的系使屏幕两边有个gap, y=10目的亦同 -> myHight-20 优化, 此处height不应该再引用 myHight, 详情见 KDBookViewController.m 引用处
        pageL.backgroundColor = [UIColor clearColor];
        pageL.numberOfLines = 0;
        pageL.font = [UIFont systemFontOfSize:[textFontSizeArray[textFontSizeIndex] floatValue]];
        pageL.lineBreakMode = UILineBreakModeWordWrap;
        pageL.textColor = [textColorSets[textColorIndex] objectForKey:@"font-color"]; //[UIColor blackColor];
        if(text != nil)
        {
            pageL.text = text;
        }
        [self addSubview:pageL];
        [pageL release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

}

/**
 *  按点击的次序, 在可用的colorSets间循环
 */
-(NSUInteger) changeColor
{
//    if(isWhiteColor)
//    {
//        isWhiteColor = NO;
//        pageL.textColor = [UIColor blackColor];
//        self.backgroundColor = [UIColor whiteColor];
//    }
//    else {
//        isWhiteColor = YES;
//        pageL.textColor = [UIColor whiteColor];
//        self.backgroundColor = [UIColor blackColor];
//    }
    
    if (textColorIndex < [textColorSets count] - 1) {
        textColorIndex++;        
    } else {
        textColorIndex = 0;
    }
    
    pageL.textColor = [textColorSets[textColorIndex] objectForKey:@"font-color"];
    self.backgroundColor = [textColorSets[textColorIndex] objectForKey:@"backgroud-color"];
    
    return textColorIndex;
}

-(void) updateTextColorByIndex:(NSUInteger) index
{
    textColorIndex = index;
    pageL.textColor = [textColorSets[textColorIndex] objectForKey:@"font-color"];
    self.backgroundColor = [textColorSets[textColorIndex] objectForKey:@"backgroud-color"];
}

-(NSUInteger) changeFontSize
{
    if (textFontSizeIndex < [textFontSizeArray count] - 1) {
        textFontSizeIndex++;
    } else {
        textFontSizeIndex = 0;
    }
    pageL.font = [UIFont systemFontOfSize:[textFontSizeArray[textFontSizeIndex] floatValue]];

    return textFontSizeIndex;
}
-(CGFloat) getTextFontSizeForTestChange
{    
    if (textFontSizeIndex < [textFontSizeArray count] - 1) {
        return [textFontSizeArray[textFontSizeIndex + 1] floatValue]; // ! not ++
    } else {
        return [textFontSizeArray[0] floatValue];
    }    
}
-(CGFloat) getTextFontSize
{
    return [textFontSizeArray[textFontSizeIndex] floatValue];
}
-(void) updateTextFontSizeByIndex:(NSUInteger) index
{
    textFontSizeIndex = index;
    pageL.font = [UIFont systemFontOfSize:[textFontSizeArray[textFontSizeIndex] floatValue]];
}

- (void)setText:(NSString *)string{
	if (text != string) {
		[text release];
		text = [string retain];
		pageL.text = text;
	}
}

- (void)dealloc {
    [textColorSets release]; // as it is
    [super dealloc];
}


@end
