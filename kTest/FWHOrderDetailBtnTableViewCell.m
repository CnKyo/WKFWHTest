//
//  FWHOrderDetailBtnTableViewCell.m
//  kTest
//
//  Created by wangke on 16/1/4.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "FWHOrderDetailBtnTableViewCell.h"

@implementation FWHOrderDetailBtnTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)layoutSubviews{
    self.FWHServiceBtn.layer.masksToBounds = YES;
    self.FWHServiceBtn.layer.cornerRadius = 4;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
