//
//  FWHLoginViewController.h
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "kBaseViewController.h"

@interface FWHLoginViewController : kBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *FWHLogo;
///
@property (weak, nonatomic) IBOutlet UITextField *FWHPhoneTx;
///
@property (weak, nonatomic) IBOutlet UITextField *FWHPwdTx;
///
@property (weak, nonatomic) IBOutlet UIView *FWHPhoneView;
///
@property (weak, nonatomic) IBOutlet UIView *FWHPasswordView;
///
@property (weak, nonatomic) IBOutlet UILabel *FWHAboutLb;
///
@property (weak, nonatomic) IBOutlet UIButton *FWHLoginBtn;
///
@property (weak, nonatomic) IBOutlet UIButton *FWHQuikBtn;

///
@property (weak, nonatomic) IBOutlet UIButton *FWHForgetBtn;
@property (weak, nonatomic) IBOutlet WPHotspotLabel *FWHExpandLb;

@property (nonatomic,strong)    UIViewController* tagVC;

@property (nonatomic,strong)    UIViewController* quikTagVC;
@end
