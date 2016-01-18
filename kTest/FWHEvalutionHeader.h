//
//  FWHEvalutionHeader.h
//  kTest
//
//  Created by wangke on 15/12/24.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHEvalutionHeader : UIView
///头像
@property (weak, nonatomic) IBOutlet UIImageView *FWHHeaderImg;
///昵称
@property (weak, nonatomic) IBOutlet UILabel *FWHName;
///好评
@property (weak, nonatomic) IBOutlet UIView *FWHGood;
///中评
@property (weak, nonatomic) IBOutlet UIView *FWHMid;
///差评
@property (weak, nonatomic) IBOutlet UIView *FWHBad;

///好评
@property (weak, nonatomic) IBOutlet UILabel *FWHGoodLb;
///中评
@property (weak, nonatomic) IBOutlet UILabel *FWHMidLb;
///差评
@property (weak, nonatomic) IBOutlet UILabel *FWHBadLb;


@property (assign,nonatomic) int All;

@property (assign,nonatomic) int Good;

@property (assign,nonatomic) int Mid;

@property (assign,nonatomic) int Bad;


///加载数据
+ (FWHEvalutionHeader *)loadViewAndData;


+ (void)initColorandView:(UIView *)view andValue:(float)mValue andYesOrNo:(BOOL)mBool;


@end
