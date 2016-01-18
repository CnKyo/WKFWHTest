//
//  FWHDateBottomView.m
//  kTest
//
//  Created by wangke on 16/1/5.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "FWHDateBottomView.h"

@implementation FWHDateBottomView

+ (FWHDateBottomView *)initWithView{
    FWHDateBottomView   *view = [[[NSBundle mainBundle] loadNibNamed:@"FWHDateBottomView" owner:self options:nil]objectAtIndex:0];
    
    view.FWHStopBtn.layer.masksToBounds = view.FWHStartBtn.layer.masksToBounds = view.FWHSelectAllBtn.layer.masksToBounds = YES;
    view.FWHStopBtn.layer.cornerRadius = view.FWHStartBtn.layer.cornerRadius = view.FWHSelectAllBtn.layer.cornerRadius = 4;
    view.FWHStopBtn.layer.borderWidth = view.FWHStartBtn.layer.borderWidth = view.FWHSelectAllBtn.layer.borderWidth = 0.75;
    view.FWHStopBtn.layer.borderWidth = view.FWHStartBtn.layer.borderWidth = view.FWHSelectAllBtn.layer.borderWidth = 0.75;
    view.FWHSelectAllBtn.layer.borderColor = [UIColor blackColor].CGColor;


    return view;
}

@end
