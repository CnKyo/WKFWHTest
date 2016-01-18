//
//  FWHTongjiViewController.h
//  kTest
//
//  Created by wangke on 16/1/13.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "kBaseViewController.h"

@interface FWHTongjiViewController : kBaseViewController
///获取统计数据,month = -1 表示 按照月份来统计,0 表示最近统计数据,
@property (nonatomic,assign) int mMonth;

@property (nonatomic,assign) int mYear;

@end
