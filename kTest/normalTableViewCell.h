//
//  normalTableViewCell.h
//  kTest
//
//  Created by wangke on 15/12/21.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface normalTableViewCell : UITableViewCell
///限时特卖按钮
@property (weak, nonatomic) IBOutlet UIButton *mTitleBtn;
///
@property (weak, nonatomic) IBOutlet UIButton *mOneBtn;
///
@property (weak, nonatomic) IBOutlet UIButton *mTwoBtn;
///
@property (weak, nonatomic) IBOutlet UIButton *mThreeBtn;


@property (strong,nonatomic) NSArray    *mtempArr;
@end
