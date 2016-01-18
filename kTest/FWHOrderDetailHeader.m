//
//  FWHOrderDetailHeader.m
//  kTest
//
//  Created by wangke on 15/12/31.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHOrderDetailHeader.h"

@implementation FWHOrderDetailHeader

+ (FWHOrderDetailHeader *)initWithView{
    FWHOrderDetailHeader *view = [[[NSBundle mainBundle]loadNibNamed:@"FWHOrderDetailHeader" owner:self options:nil] objectAtIndex:0];
    
    view.FWHHeaderImg.layer.masksToBounds = YES;
    view.FWHHeaderImg.layer.cornerRadius = 3.5;
    
    return view;
}

@end
