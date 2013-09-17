//
//  RJAboutView.h
//  RJTxtReader
//
//  Created by ahming on 13-9-17.
//
//

#import <UIKit/UIKit.h>

@interface RJAboutView : UIView
{
    UITableView *aboutView;
    UITextView *aboutDesc;
}

- (void)loadCustomView;

@end
