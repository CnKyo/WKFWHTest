//
//  WKDownTimeBtn.h
//  kTest
//
//  Created by wangke on 16/1/12.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WKDownTimeBtn)
///时间，开始标签，子标签，选择的颜色，未选择的颜色
- (void)startDownTime:(NSInteger)mTime andStartTitele:(NSString *)mTitle andSubTitle:(NSString *)mSubTitle andSelectedColor:(UIColor *)mSelectedColor andUnSelectedColor:(UIColor *)mUnSelectedColor;

@end
