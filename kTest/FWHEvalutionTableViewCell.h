//
//  FWHEvalutionTableViewCell.h
//  kTest
//
//  Created by wangke on 15/12/24.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWHEvalutionTableViewCell : UITableViewCell
///昵称
@property (weak, nonatomic) IBOutlet UILabel *FWHName;
///状态
@property (weak, nonatomic) IBOutlet UILabel *FWHStatus;
///内容
@property (weak, nonatomic) IBOutlet UILabel *FWHContent;
///图片
@property (weak, nonatomic) IBOutlet UIView *FWHImgView;
///服务名称
@property (weak, nonatomic) IBOutlet UILabel *FWHServiceName;
///时间
@property (weak, nonatomic) IBOutlet UILabel *FWHTime;

@property (nonatomic,strong) SSEvolution    *model;

@property (assign,nonatomic)CGFloat cellH;
@end
