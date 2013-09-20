

#import "ReaderConstants.h"
#import "PageView.h"


@implementation PageView
@synthesize text;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		text = nil;
        isWhiteColor = NO;
        
        self.backgroundColor = [UIColor whiteColor];
        
        pageL = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, self.frame.size.width-20, self.frame.size.height-20)]; // ahming-marks-page     myHight-20 应该指减去状态栏的高度, x=15和width-20目的系使屏幕两边有个gap, y=10目的亦同 -> myHight-20 优化, 此处height不应该再引用 myHight, 详情见 KDBookViewController.m 引用处
        pageL.backgroundColor = [UIColor clearColor];
        pageL.numberOfLines = 0;
        pageL.font = [UIFont systemFontOfSize:18];		
        pageL.lineBreakMode = UILineBreakModeWordWrap;
        pageL.textColor = [UIColor blackColor];
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

-(void) changeColor
{
    if(isWhiteColor)
    {
        isWhiteColor = NO;
        pageL.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    else {
        isWhiteColor = YES;
        pageL.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor blackColor];
    }
}

- (void)setText:(NSString *)string{
	if (text != string) {
		[text release];
		text = [string retain];
		pageL.text = text;
	}
}


- (void)dealloc {
    [super dealloc];
}


@end
