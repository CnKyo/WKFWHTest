//
//  likeCell.h
//  kTest
//
//  Created by wangke on 15/12/21.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mHeaderBtnSelected <NSObject>

@optional

- (void)didSelectedBtnWithIndex:(NSInteger)index;

@end

@interface likeCell : UITableViewCell
///图片的url数组
@property (nonatomic,strong) NSArray    *imageArr;

@property (nonatomic,strong) id<mHeaderBtnSelected> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)mFrame;
@end
