//
//  FWHEvalutionHeader.m
//  kTest
//
//  Created by wangke on 15/12/24.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHEvalutionHeader.h"

@interface FWHEvalutionHeader()

@end

@implementation FWHEvalutionHeader
{

}

+ (FWHEvalutionHeader *)loadViewAndData{
    
    FWHEvalutionHeader  *view = [[[NSBundle mainBundle] loadNibNamed:@"FWHEvalutionHeader" owner:self options:nil] objectAtIndex:0];

    view.FWHHeaderImg.layer.masksToBounds = YES;
    view.FWHHeaderImg.layer.cornerRadius = 3;
    
    
    mUser *nowUser = [mUser backNowUser];
    
    if ( nowUser ) {

    }
    
    if (view.All) {
        
        float   mValue = view.Good/(float)view.All;
        [self initColorandView:view.FWHGood andValue:mValue andYesOrNo:YES];
        view.FWHGoodLb.text = [NSString stringWithFormat:@"%.1f%%",mValue*100];

        mValue = view.Mid/(float)view.All;
        [self initColorandView:view.FWHMid andValue:mValue andYesOrNo:YES];
        view.FWHMidLb.text = [NSString stringWithFormat:@"%.1f%%",mValue*100];

        
        mValue = view.Bad/(float)view.All;
        [self initColorandView:view.FWHBad andValue:mValue andYesOrNo:YES];
        view.FWHBadLb.text = [NSString stringWithFormat:@"%.1f%%",mValue*100];


    }
    
    return view;
    
}

+ (void)initColorandView:(UIView *)view andValue:(float)mValue andYesOrNo:(BOOL)mBool{
    
    view.layer.borderColor = [UIColor colorWithWhite:0.812 alpha:1.000].CGColor;
    view.layer.borderWidth = 0.5f;
    view.layer.cornerRadius = 0.3f;
    
    UIView  *mBgkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, view.frame.size.height)];
    [view addSubview:mBgkView];
    
    view.backgroundColor = [UIColor whiteColor];
    mBgkView.backgroundColor = M_CO;
    
    if ( mBool ) {
        [UIView animateWithDuration:1 animations:^{
            
            CGRect rect = mBgkView.frame;
            rect.size.width = mValue * view.bounds.size.width;
            mBgkView.frame = rect;
            
        }];
    }else{
        CGRect rect = mBgkView.frame;
        rect.size.width = mValue * view.bounds.size.width;
        mBgkView.frame = rect;
    }

}

@end
