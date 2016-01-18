//
//  FWHOrderTableViewCell.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHOrderTableViewCell.h"
#import <MapKit/MapKit.h>

@implementation FWHOrderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews{
    [super layoutSubviews];

    self.mPayType.layer.masksToBounds  = YES;
    self.mPayType.layer.cornerRadius = 3;
    
    self.mSn.text = _model.mSn;
    self.mAddress.text = _model.mAddress;
    self.mServiceName.text = _model.mServiceName;
    self.mPrice.text = [NSString stringWithFormat:@"¥%.2f元",_model.mTotalMoney];
    self.mName.text = _model.mUserName;
    self.mCreatOrderTime.text = _model.mApptime;
    self.mPhone.text = _model.mPhoneNum;
    self.mPayType.text = @"在线支付";
    self.mOrderStatus.text = _model.mOrderStateStr;
    [self.mNavBtn addTarget:self action:@selector(navAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.mConnectBtn addTarget:self action:@selector(connectAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)navAction:(UIButton *)sender{
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=0", [HTTPRequest getAppScheme],[HTTPRequest getAppName],_model.mLat, _model.mLongit] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //跳转到高德地图
    NSString* ampurl = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=0",[HTTPRequest getAppScheme],[HTTPRequest getAppName],_model.mLat,_model.mLongit];
    
    if( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]] )
    {//
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
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

- (void)connectAction:(UIButton *)sender{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.mPhoneNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
