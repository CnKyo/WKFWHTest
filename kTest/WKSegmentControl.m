//
//  WKSegmentControl.m
//  kTest
//
//  Created by wangke on 16/1/4.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "WKSegmentControl.h"

@interface WKSegmentControl ()<WKSegmentControlDelagate>{
    
    ///每个按钮的宽
    CGFloat mBtnWith;
    ///按钮下面的线
    UIView * mUnderLine;
    ///一共有多少个按钮
    NSInteger mTotleCount;
    ///纪录最后选择了那一个
    NSInteger mLastSelect;
    ///线的宽率
    int y;
    
}

@end

@implementation WKSegmentControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.FWHBtnArr = [NSMutableArray new];
        mLastSelect = 0;
        
    }
    return self;
}

+ (WKSegmentControl *)initWithSegmentControlFrame:(CGRect)frame andTitleWithBtn:(NSArray *)btnTitleArr andBackgroudColor:(UIColor *)mBackgroudColor andBtnSelectedColor:(UIColor *)btnSelectedColor andBtnTitleColor:(UIColor *)btnTitleColor andUndeLineColor:(UIColor *)btnUndeLineColor andBtnTitleFont:(UIFont *)btnTitleFont andInterval:(int)mInterVal delegate:(id)delegate{
    
    WKSegmentControl    *mSegment = [[self alloc] initWithFrame:frame];
    mSegment.backgroundColor = mBackgroudColor;
    mSegment.FWHUnderLineColor = btnUndeLineColor;
    mSegment.FWHInterVal = mInterVal;
    mSegment.FWHBtnTitelColor = btnTitleColor;
    mSegment.FWHBtnFont = btnTitleFont;
    
    mSegment.FWHBtnSelectedColor = btnSelectedColor;
    mSegment.delegate = delegate;
    [mSegment loadArrWithView:btnTitleArr];
    return mSegment;
    
}
#pragma mark----通过数组构造view
- (void)loadArrWithView:(NSArray *)mArray{
    
    // 1.按钮的个数
    mTotleCount = mArray.count;
    
    // 2.按钮的宽度
    mBtnWith = (self.bounds.size.width) / mTotleCount;
    
    // 3.创建按钮
    for (int i = 0; i < mArray.count; i++) {
        
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i * mBtnWith, 0, mBtnWith, self.bounds.size.height - 2)];
        [btn setTitle:mArray[i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:self.FWHBtnFont];
        [btn setTitleColor:self.FWHBtnTitelColor forState:UIControlStateNormal];
        [btn setTitleColor:self.FWHBtnSelectedColor forState:UIControlStateSelected];
        btn.tag = i + 1;
        [btn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            
            if (mTotleCount==2) {
                y = _FWHInterVal*2;
            }else if (mTotleCount>2){
                y = _FWHInterVal;
            }
            mUnderLine =[[UIView alloc]initWithFrame:CGRectMake(i * mBtnWith+y, self.bounds.size.height - 2, mBtnWith-2*y, 2)];
            [mUnderLine setBackgroundColor:self.FWHUnderLineColor];
            
            [self addSubview:mUnderLine];
        }
        [self addSubview:btn];
        
        [self.FWHBtnArr addObject:btn];
    }
    [[self.FWHBtnArr firstObject] setSelected:YES];
}

- (void)changeBtnAction:(UIButton *)btn{
    [self selectTheSegument:btn.tag - 1];
}

-(void)selectTheSegument:(NSInteger)segument{
    
    if (mLastSelect != segument) {
        
        [self.FWHBtnArr[mLastSelect] setSelected:NO];
        [self.FWHBtnArr[segument] setSelected:YES];
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (mTotleCount==2) {
                y = _FWHInterVal*2;
            }else if (mTotleCount>2){
                y = _FWHInterVal;
            }
            
            [mUnderLine setFrame:CGRectMake(segument * mBtnWith+y,self.bounds.size.height - 2, mBtnWith-2*y, 2)];
        }];
        mLastSelect = segument;
        [self.delegate WKDidSelectedIndex:mLastSelect];
    }
}


@end
