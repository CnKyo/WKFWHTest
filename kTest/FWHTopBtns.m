//
//  FWHTopBtns.m
//  kTest
//
//  Created by wangke on 15/12/25.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHTopBtns.h"

@interface FWHTopBtns()
{
    NSInteger selectSeugment;

}
@end

@implementation FWHTopBtns

- (FWHTopBtns *)initWithBtnData:(NSArray *)mArray{

    FWHTopBtns  *view = [[[NSBundle mainBundle] loadNibNamed:@"FWHTopBtns" owner:self options:nil] objectAtIndex:0];

    self.btnArray = [[NSMutableArray alloc] initWithCapacity:[mArray count]];
    selectSeugment = 0;
    
    int x = 0;
    
    for (int i = 0; i<4; i++) {
        
        _FWHLastBtn = [UIButton new];
        _FWHLastBtn.frame = CGRectMake(x, 10, DEVICE_Width/4, 30);
        [_FWHLastBtn setTitle:mArray[i] forState:0];
        _FWHLastBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_FWHLastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_FWHLastBtn setTitleColor:M_CO forState:UIControlStateSelected];
        _FWHLastBtn.tag = i;
        [_FWHLastBtn addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_FWHLastBtn];
        
        UIView *mBottomLine =[[UIView alloc]initWithFrame:CGRectMake(0, 59, DEVICE_Width, 0.5f)];
        mBottomLine.backgroundColor = [UIColor colorWithRed:0.867 green:0.859 blue:0.859 alpha:1.000];
        [view addSubview:mBottomLine];
        
        [self.btnArray addObject:_FWHLastBtn];
        
        x += DEVICE_Width/4;

        [[self.btnArray firstObject] setSelected:YES];
        
    }
    
    return view;

}
- (void)selectBtnAction:(UIButton *)sender{
    
    if (selectSeugment != sender.tag) {
        [self.btnArray[selectSeugment] setSelected:NO];
        [self.btnArray[sender.tag] setSelected:YES];
        selectSeugment = sender.tag;

    }
    
    
    [UIView animateWithDuration:0.15 animations:^{
        CGRect  rect = self.FWHLineView.frame;
        rect.origin.x = sender.frame.origin.x+15;
        self.FWHLineView.frame = rect;
    }];
    
    [self.delegate didSelectedBtnWithIndexPath:sender.tag];
}

@end
