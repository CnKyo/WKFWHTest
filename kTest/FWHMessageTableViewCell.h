//
//  FWHMessageTableViewCell.h
//  kTest
//
//  Created by wangke on 16/1/14.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHMessageTableViewCell : UITableViewCell
///标签
@property (weak, nonatomic) IBOutlet UILabel *FWHTitle;
///时间
@property (weak, nonatomic) IBOutlet UILabel *FWHTime;
///内容
@property (weak, nonatomic) IBOutlet UILabel *FWHContent;
///消息点
@property (weak, nonatomic) IBOutlet UIImageView *FWHPoint;

@property (strong,nonatomic) SSMessage  *model;
@end
