//
//  RJAboutView.m
//  RJTxtReader
//
//  Created by ahming on 13-9-17.
//
//

#import "ReaderConstants.h"
#import "RJAboutView.h"

#import "QuartzCore/QuartzCore.h"

@implementation RJAboutView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self loadCustomView];
    }
    return self;
}

- (void)loadCustomView
{
    //加上背景
    CGRect rect = CGRectMake(0, 0, 320, myHight-45);
    UIImageView* backView = [[UIImageView alloc]initWithFrame:rect];
    backView.image = [UIImage imageNamed:@"background.jpg"];

    aboutView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, myHight-45)];
    aboutView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [aboutView setBackgroundView:backView];
    [self addSubview:aboutView];
    
    aboutDesc = [[UITextView alloc] initWithFrame:CGRectMake(10, 20, 300, 100)];
    [aboutDesc setText:NSLocalizedString(@"about.desc", nil)];
    aboutDesc.textColor = [UIColor whiteColor];
    aboutDesc.backgroundColor = [UIColor clearColor]; // 透明背景
    aboutDesc.editable = NO;
    [aboutDesc.layer setCornerRadius:10];
    //aboutDesc.scrollEnabled = YES;//是否可以拖动
    //aboutDesc.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    
    [self addSubview:aboutDesc];
    
    [aboutDesc release];
    [backView release];
    [aboutView release];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
