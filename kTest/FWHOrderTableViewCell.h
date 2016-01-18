//
//  FWHOrderTableViewCell.h
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHOrderTableViewCell : UITableViewCell
///下单时间
@property (weak, nonatomic) IBOutlet UILabel *mCreatOrderTime;
///服务名称
@property (weak, nonatomic) IBOutlet UILabel *mServiceName;
///订单编号
@property (weak, nonatomic) IBOutlet UILabel *mSn;
///姓名
@property (weak, nonatomic) IBOutlet UILabel *mName;
///电话
@property (weak, nonatomic) IBOutlet UILabel *mPhone;
///地址
@property (weak, nonatomic) IBOutlet UILabel *mAddress;
///支付方式
@property (weak, nonatomic) IBOutlet UILabel *mPayType;
///价格
@property (weak, nonatomic) IBOutlet UILabel *mPrice;
///导航
@property (weak, nonatomic) IBOutlet UIButton *mNavBtn;
///联系电话
@property (weak, nonatomic) IBOutlet UIButton *mConnectBtn;
///订单状态
@property (weak, nonatomic) IBOutlet UILabel *mOrderStatus;
///
@property (strong,nonatomic) SSOrder   *model;
@end
