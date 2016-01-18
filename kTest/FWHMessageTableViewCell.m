//
//  FWHMessageTableViewCell.m
//  kTest
//
//  Created by wangke on 16/1/14.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "FWHMessageTableViewCell.h"

@implementation FWHMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    self.FWHContent.text = _model.mContent;
    self.FWHTime.text = _model.mSendTime;
    self.FWHTitle.text = _model.mTitle;
    
    self.FWHPoint.hidden = _model.mRead;
  
}
@end
