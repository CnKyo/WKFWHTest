//
//  FWHMoreHeaderView.m
//  kTest
//
//  Created by wangke on 15/12/25.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHMoreHeaderView.h"

@implementation FWHMoreHeaderView

+ (FWHMoreHeaderView *)initWithHeaderView{
    FWHMoreHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"FWHMoreHeaderView" owner:self options:nil] objectAtIndex:0];
    view.FWHHeaderImg.layer.masksToBounds = YES;
    view.FWHHeaderImg.layer.cornerRadius = view.FWHHeaderImg.mwidth/2;
    
    view.FWHHeaderBlockView.layer.masksToBounds = view.FWHFooterBlockView.layer.masksToBounds = YES;
    view.FWHHeaderBlockView.layer.borderWidth = view.FWHFooterBlockView.layer.borderWidth = 0.4;
    view.FWHHeaderBlockView.layer.borderColor = view.FWHFooterBlockView.layer.borderColor = [UIColor colorWithRed:0.667 green:0.667 blue:0.667 alpha:1].CGColor;
    
    return view;
}


+ (FWHMoreHeaderView *)initWithFooterView{
    FWHMoreHeaderView *view = [[[NSBundle mainBundle] loadNibNamed:@"FWHMoreFootView" owner:self options:nil] objectAtIndex:0];
    view.FWHLoginOut.layer.masksToBounds = YES;
    view.FWHLoginOut.layer.cornerRadius = 4;
    
    return view;
}
@end
