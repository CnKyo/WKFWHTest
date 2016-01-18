//
//  FWHDateBottomView.h
//  kTest
//
//  Created by wangke on 16/1/5.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHDateBottomView : UIView
///停止接单
@property (weak, nonatomic) IBOutlet UIButton *FWHStopBtn;
///开始接单
@property (weak, nonatomic) IBOutlet UIButton *FWHStartBtn;
///全选
@property (weak, nonatomic) IBOutlet UIButton *FWHSelectAllBtn;

+(FWHDateBottomView *)initWithView;


@end
