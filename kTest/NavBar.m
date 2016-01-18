//
//  NavBar.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "NavBar.h"

@interface NavBar ()

@end

@implementation NavBar
{
    UIImageView *bgimageview;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = COLOR(231, 105, 105);
        // self.backgroundColor = [UIColor redColor];
        
        // Initialization code
        
        self.frame = CGRectMake(0, 0, DEVICE_Width, DEVICE_NavBar_Height);
        bgimageview = [[UIImageView alloc]initWithFrame:self.frame];
        bgimageview.image = [UIImage imageNamed:@"navbg-1"];
        [self addSubview:bgimageview];
        [self loadView];
    }
    return self;
}
- (void)leftBtnTouched:(id)sender {
    [self.NavDelegate leftBtnTouched:sender];
    
}
-(void)setBgImage:(UIImage *)bgImage
{
    bgimageview.image = bgImage;
}
-(void)setBgColor:(UIColor *)bgColor
{
    bgimageview.backgroundColor = bgColor;
}
-(void)rightbtnTouched:(id)sender
{
    [self.NavDelegate rightBtnTouched:sender];
}

- (void)AbtnTouched:(id)sender{
    [self.NavDelegate ABtnTouched:sender];
}
- (void)BbtnTouched:(id)sender{
    [self.NavDelegate BBtnTouched:sender];
}
-(void)loadView
{
    
    UIView *mLine = [UIView new];
    mLine.hidden = NO;
    mLine.frame = CGRectMake(0, DEVICE_NavBar_Height-0.5, DEVICE_Width, 0.5);
    mLine.backgroundColor = [UIColor colorWithRed:0.867 green:0.867 blue:0.867 alpha:1];
    [self addSubview:mLine];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.leftBtn setTitleColor:[UIColor whiteColor] forState:0];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:0];
    
    self.ABtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.BBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (SystemIsiOS7()) {
        self.leftBtn.frame = CGRectMake(0, 20,100, 44);
        self.leftBtn.imageEdgeInsets  = UIEdgeInsetsMake(0, 0, 0, 20);
        self.leftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
        self.rightBtn.frame = CGRectMake(DEVICE_Width-60, 20, 60, 44);
        self.rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        self.titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        self.titleLabel.center = self.center;
        CGRect rect = self.titleLabel.frame;
        rect.origin.y+=10;
        self.titleLabel.frame = rect;
        
        self.ABtn.frame = CGRectMake(DEVICE_Width-100, 20, 45, 44);
        self.BBtn.frame = CGRectMake(DEVICE_Width-49, 20, 45, 44);
        
        
    }
    else
    {
        
        self.ABtn.frame = CGRectMake(DEVICE_Width-90, 20, 45, 44);
        self.BBtn.frame = CGRectMake(DEVICE_Width-39, 20, 45, 44);
        
        self.leftBtn.frame = CGRectMake(0, 0,50, 60);
        self.rightBtn.frame = CGRectMake(DEVICE_Width-50, 0, 50, 44);
        
        self.titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        self.titleLabel.center = self.center;

    }
    
    [self.ABtn addTarget:self action:@selector(AbtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.BBtn addTarget:self action:@selector(BbtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.ABtn];
    [self addSubview:self.BBtn];

    [self.leftBtn setImage:[UIImage imageNamed:@"backBtna"] forState:UIControlStateNormal];
    self.leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
    [self addSubview:self.leftBtn];
    
    [self.rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:self.rightBtn];
    [self.rightBtn addTarget:self action:@selector(rightbtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn addTarget:self action:@selector(leftBtnTouched:) forControlEvents:UIControlEventTouchUpInside];

    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:self.titleLabel];
}


@end
