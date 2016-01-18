//
//  FWHTongjiTableViewCell.h
//  kTest
//
//  Created by wangke on 16/1/13.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHTongjiTableViewCell : UITableViewCell
///图片
@property (weak, nonatomic) IBOutlet UIImageView *FWHImg;
///服务名称
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceName;
///日期
@property (weak, nonatomic) IBOutlet UILabel *FWHDate;
///价格
@property (weak, nonatomic) IBOutlet UILabel *FWHPrice;
///订单对象
@property (strong,nonatomic) SStatistical    *model;

///月
@property (weak, nonatomic) IBOutlet UILabel *mMonth;
///年
@property (weak, nonatomic) IBOutlet UILabel *mYear;
///总数
@property (weak, nonatomic) IBOutlet UILabel *mNum;
///价格
@property (weak, nonatomic) IBOutlet WPHotspotLabel *mPrice;

@end
