//
//  FWHTongjiTableViewCell.m
//  kTest
//
//  Created by wangke on 16/1/13.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "FWHTongjiTableViewCell.h"

@implementation FWHTongjiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews{

    self.FWHImg.layer.masksToBounds = YES;
    self.FWHImg.layer.cornerRadius = 3;
    
    [self.FWHImg sd_setImageWithURL:[NSURL URLWithString:_model.mImgURL] placeholderImage:[UIImage imageNamed:@"img_def"]];
    self.FWHDate.text = _model.mTimeStr;
    self.FWHPrice.text = [NSString stringWithFormat:@"¥%.2f",_model.mTotal];
    self.FWHServiceName.text = _model.mSrvName;
    
    
    NSDictionary *mStyle2 = @{@"acolor": [UIColor lightGrayColor],@"bcolor": M_CO};
    
    self.mYear.text = [NSString stringWithFormat:@"%d年",_model.mYear];
    self.mMonth.text = [NSString stringWithFormat:@"%d月",_model.mMonth];
    self.mNum.text = [NSString stringWithFormat:@"成交%d笔",_model.mNum];
    self.mPrice.attributedText = [[NSString stringWithFormat:@"<acolor>%@</acolor><bcolor>¥%.2f</bcolor>",@"累计收入：",_model.mTotal] attributedStringWithStyleBook:mStyle2];
}
@end
