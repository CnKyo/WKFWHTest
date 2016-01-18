//
//  FWHOrderDetailTableViewCell.m
//  kTest
//
//  Created by wangke on 15/12/31.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHOrderDetailTableViewCell.h"
#import <MapKit/MapKit.h>

@implementation FWHOrderDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews{

    self.FWHServiceTime.text =[NSString stringWithFormat:@"服务时间：%@",_model.mCreateOrderTimeWithWeek];
    self.FWHServiceName.text =[NSString stringWithFormat:@"联系人：%@",_model.mUserName];
    self.FWHPhone.text = [NSString stringWithFormat:@"联系电话:%@",_model.mPhoneNum];
    self.FWHAddress.text = _model.mAddress;
    self.FWHOrderId.text = [NSString stringWithFormat:@"订单编号:%@",_model.mSn];
    self.FWHNote.text = _model.mReMark;

    if (self.FWHAddress.text.length == 0) {
        self.FWHAddress.text = @"未知地址！";
    }
    if (self.FWHNote.text.length == 0) {
        self.FWHNote.text = @"暂无备注!";
    }
    
    self.FWHPrice.text = [NSString stringWithFormat:@"费用:¥%.2f元",_model.mTotalMoney];
    self.FWHOrderStatus.text = _model.mOrderStateStr;
    self.FWHPhoneBtn.layer.masksToBounds = self.FWHNavBtn.layer.masksToBounds = YES;
    self.FWHPhoneBtn.layer.cornerRadius = self.FWHNavBtn.layer.cornerRadius = 3.5;
    self.FWHPhoneBtn.layer.borderColor = self.FWHNavBtn.layer.borderColor = COLOR(68, 183, 77).CGColor;
    self.FWHPhoneBtn.layer.borderWidth = self.FWHNavBtn.layer.borderWidth = 0.5;
    
    
    [self.FWHPhoneBtn addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.FWHNavBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)connectAction:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)navAction:(UIButton *)sender{
    //跳转到高德地图
    NSString* ampurl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=testapp&backScheme=zyseller&lat=%.7f&lon=%.7f&dev=0&style=0",_model.mLat,_model.mLongit];
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:ampurl]] )
    {//
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ampurl]];
    }
    else
    {//ioS map
        
        CLLocationCoordinate2D to;
        to.latitude =  _model.mLat;
        to.longitude =  _model.mLongit;
        
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil] ];
        toLocation.name = _model.mAddress;
        [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil]
                       launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil]
                                                                 forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
    }

}
@end
