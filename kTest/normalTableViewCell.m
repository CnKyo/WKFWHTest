//
//  normalTableViewCell.m
//  kTest
//
//  Created by wangke on 15/12/21.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "normalTableViewCell.h"

@implementation normalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMtempArr:(NSArray *)mtempArr{

    [self.mOneBtn setBackgroundImage:mtempArr[0] forState:0];
    [self.mTwoBtn setBackgroundImage:mtempArr[1] forState:0];
    [self.mThreeBtn setBackgroundImage:mtempArr[2] forState:0];

}
@end
