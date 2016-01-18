//
//  FWHMoreHeaderView.h
//  kTest
//
//  Created by wangke on 15/12/25.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHMoreHeaderView : UIView
///
@property (weak, nonatomic) IBOutlet UIView *FWHHeaderBlockView;
///
@property (weak, nonatomic) IBOutlet UIView *FWHFooterBlockView;

///头像
@property (weak, nonatomic) IBOutlet UIImageView *FWHHeaderImg;
///昵称
@property (weak, nonatomic) IBOutlet UILabel *FWHName;
///电话
@property (weak, nonatomic) IBOutlet UILabel *FWHPhone;
///退出按钮
@property (weak, nonatomic) IBOutlet UIButton *FWHLoginOut;

+ (FWHMoreHeaderView *)initWithHeaderView;

+ (FWHMoreHeaderView *)initWithFooterView;
@end
