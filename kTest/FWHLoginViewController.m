//
//  FWHLoginViewController.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHLoginViewController.h"

@interface FWHLoginViewController ()<UITextFieldDelegate>

@end

@implementation FWHLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"登录";
    self.navBar.leftBtn.hidden = YES;
    self.hiddenRightBtn = YES;
    self.hiddenTabBar = YES;
    [self initView];

}
- (void)initView{
    self.FWHLogo.layer.masksToBounds = YES;
    self.FWHLogo.layer.cornerRadius = 3.5;
    self.FWHPhoneView.layer.masksToBounds = self.FWHPasswordView.layer.masksToBounds = YES;
    self.FWHPhoneView.layer.cornerRadius = self.FWHPasswordView.layer.cornerRadius = 4;
    self.FWHPhoneView.layer.borderColor = self.FWHPasswordView.layer.borderColor = COLOR(186, 186, 186).CGColor;
    self.FWHPhoneView.layer.borderWidth = self.FWHPasswordView.layer.borderWidth = 0.75;
    
    self.FWHLoginBtn.layer.masksToBounds = YES;
    self.FWHLoginBtn.layer.cornerRadius = 4;
    
    self.FWHPhoneTx.delegate = self.FWHPwdTx.delegate = self;
    
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
    
    NSDictionary *mStyle2 = @{@"Action":[WPAttributedStyleAction styledActionWithAction:^{
        lll(@"免责申明");
    }],@"color": COLOR(64, 128, 0)};
    
    self.FWHExpandLb.attributedText = [[NSString stringWithFormat:@"%@<Action>《免责申明》</Action>",@"点击“登录”，即表示您同意"] attributedStringWithStyleBook:mStyle2];

    
}
- (void)tapAction:(id)sender{
    [self.FWHPhoneTx resignFirstResponder];
    [self.FWHPwdTx resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)FWHBtnAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            lll(@"登录");
            if (self.FWHPhoneTx.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"手机号不能为空！"];
                [self.FWHPhoneTx becomeFirstResponder];
                return;
            }
            if (self.FWHPwdTx.text.length == 0) {
                [SVProgressHUD showErrorWithStatus:@"密码不能为空！"];
                [self.FWHPwdTx becomeFirstResponder];
                return;
            }
            if (![Util isMobileNumber:self.FWHPhoneTx.text]) {
                [SVProgressHUD showErrorWithStatus:@"手机号码错误！"];
                [self.FWHPhoneTx becomeFirstResponder];
                return;
            }

            [mUser loginWithPhone:self.FWHPhoneTx.text andPwd:self.FWHPwdTx.text block:^(mBaseModel *mData, mUser *mUser) {
                if (mData.mSucsess) {
                    [SVProgressHUD showSuccessWithStatus:mData.mMessege];
                    [self loginOk];

                }else{
                
                    [SVProgressHUD showErrorWithStatus:mData.mMessege];
                }
            }];
        }
            break;
        case 2:
        {
            lll(@"快捷登录");

        }
            break;
        case 3:
        {
            lll(@"忘记密码");

        }
            break;
        default:
            break;
    }
}

#pragma mark----登录成功跳转
- (void)loginOk{
    
    if( self.quikTagVC )
    {
        [self setToViewController_2:self.quikTagVC];
    }
    else
    {
        [self popViewController_2];
    }
    
}

///限制电话号码输入长度
#define TEXT_MAXLENGTH 11
///限制妈妈输入长度
#define PASS_LENGHT 20
#pragma mark **----键盘代理方法
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res;
    if (textField.tag==20) {
        res= PASS_LENGHT-[new length];
        
        
    }else
    {
        res= TEXT_MAXLENGTH-[new length];
        
    }
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[string length]+res};
        if (rg.length>0) {
            NSString *s = [string substringWithRange:rg];
            [textField setText:[textField.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
}
@end
