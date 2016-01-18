//
//  FWHTopBtns.h
//  kTest
//
//  Created by wangke on 15/12/25.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FWHBtnDelegate <NSObject>

@optional

- (void)didSelectedBtnWithIndexPath:(NSInteger)index;

@end

@interface FWHTopBtns : UIView

@property (nonatomic,strong) id<FWHBtnDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *FWHLineView;

@property (strong, nonatomic) UIButton *FWHLastBtn;

@property (strong, nonatomic)NSMutableArray *btnArray;


- (FWHTopBtns *)initWithBtnData:(NSArray *)mArray;

@end
