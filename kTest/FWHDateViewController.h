//
//  FWHDateViewController.h
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "kBaseViewController.h"

@interface FWHDateViewController : kBaseViewController
@property (nonatomic,weak) FWHDateViewController    *FWHPushSelf;
///是否是编辑界面
@property (nonatomic,assign) BOOL   mIsEditing;

@end
