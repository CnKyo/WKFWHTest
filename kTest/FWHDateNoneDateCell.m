//
//  FWHDateNoneDateCell.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHDateNoneDateCell.h"

@implementation FWHDateNoneDateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    self.FWHTime.text = _model.mTimeStr;
    
    if (_model.mbStringInfo) {
        self.FWHContent.text = _model.mStr;
    }else{
    
        if( _model.mSrvName.length != 0 )
            self.FWHServiceName.text = _model.mSrvName;
        else
            self.FWHServiceName.text = @"";
        
        if( _model.mUserName.length != 0 )
            self.FWHPhone.text = [NSString stringWithFormat:@"%@%@",_model.mUserName,_model.mPhone ];
        else
            self.FWHPhone.text = @"";
        
        if( _model.mAddress.length != 0 )
            self.FWHAddress.text = [NSString stringWithFormat:@"%@",_model.mAddress];
        else
            self.FWHAddress.text = @"";
    }
    
    if (_model.mChecked) {
        [self.FWHBtnImg setBackgroundImage:[UIImage imageNamed:@"paychoose"] forState:0];
    }else{
        [self.FWHBtnImg setBackgroundImage:[UIImage imageNamed:@"paynotchoos"] forState:0];
    }

}
@end
