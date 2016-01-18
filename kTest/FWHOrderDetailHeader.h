//
//  FWHOrderDetailHeader.h
//  kTest
//
//  Created by wangke on 15/12/31.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHOrderDetailHeader : UIView
///图片
@property (weak, nonatomic) IBOutlet UIImageView *FWHHeaderImg;
///服务名称
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceName;
///计价方式
@property (weak, nonatomic) IBOutlet UILabel *FWHPriceType;
///服务时长
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceTime;

+ (FWHOrderDetailHeader *)initWithView;
@end
