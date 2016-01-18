//
//  FWHOrderDetailTableViewCell.h
//  kTest
//
//  Created by wangke on 15/12/31.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHOrderDetailTableViewCell : UITableViewCell
///服务数量
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceNum;
///服务时间
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceTime;
///联系人
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceName;
///联系电话
@property (weak, nonatomic) IBOutlet UILabel *FWHPhone;
///拨打电话
@property (weak, nonatomic) IBOutlet UIButton *FWHPhoneBtn;
///服务地址
@property (weak, nonatomic) IBOutlet UILabel *FWHAddress;
///导航按钮
@property (weak, nonatomic) IBOutlet UIButton *FWHNavBtn;
///订单编号
@property (weak, nonatomic) IBOutlet UILabel *FWHOrderId;
///备注
@property (weak, nonatomic) IBOutlet UILabel *FWHNote;
///费用
@property (weak, nonatomic) IBOutlet UILabel *FWHPrice;
///支付状态
@property (weak, nonatomic) IBOutlet UILabel *FWHOrderStatus;


@property (strong,nonatomic) SSOrder   *model;

@end
