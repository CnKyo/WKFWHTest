//
//  FWHDateNoneDateCell.h
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHDateNoneDateCell : UITableViewCell
///时间
@property (weak, nonatomic) IBOutlet UILabel *FWHTime;
///内容
@property (weak, nonatomic) IBOutlet UILabel *FWHContent;
///图标
@property (weak, nonatomic) IBOutlet UIButton *FWHBtnImg;
///服务名称
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceName;
///电话
@property (weak, nonatomic) IBOutlet UILabel *FWHPhone;
///地址
@property (weak, nonatomic) IBOutlet UILabel *FWHAddress;
///日程对象
@property (strong,nonatomic) SScheduleItem  *model;

@end
