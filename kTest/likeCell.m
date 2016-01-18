//
//  likeCell.m
//  kTest
//
//  Created by wangke on 15/12/21.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "likeCell.h"

@interface likeCell()
{
    UIScrollView    *mScrollerView;
}
@end

@implementation likeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andFrame:(CGRect)mFrame{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        ///创建scrollerView
        mScrollerView = [UIScrollView new];
        mScrollerView.frame = CGRectMake(5, 0, mFrame.size.width, mFrame.size.height);
        mScrollerView.showsHorizontalScrollIndicator = NO;
        [self addSubview:mScrollerView];
        
        //添加图片
        for (int i = 0; i < 10; ++i) {
            CGFloat width = 70;
            CGFloat height = 70;
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake((width+5)*i, 0, width, mFrame.size.height)];
            backView.tag = 80+i;
            backView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapImage:)];
            [backView addGestureRecognizer:tap];
            [mScrollerView addSubview:backView];

            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, width, height)];
            imageView.layer.masksToBounds = YES;
            imageView.layer.cornerRadius = imageView.frame.size.width/2;
            //            [imageView setImage:[UIImage imageNamed:@"lesson_default"]];
            imageView.tag = i+20;
            [backView addSubview:imageView];
            
            //电影名
            UILabel *movieNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame), width, 25)];
            movieNameLabel.tag = i+40;
            movieNameLabel.font = [UIFont systemFontOfSize:13];
            movieNameLabel.textAlignment = NSTextAlignmentCenter;
            [backView addSubview:movieNameLabel];
        }
        
    }
    return self;

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImageArr:(NSArray *)imageArr{
    CGFloat width = 85;
    if (imageArr.count>10) {
        mScrollerView.contentSize = CGSizeMake((width+5)*10+5, mScrollerView.frame.size.height);
    }else{
        mScrollerView.contentSize = CGSizeMake((width+5)*imageArr.count+5, mScrollerView.frame.size.height);
    }
    for (int i = 0; i < imageArr.count; i++) {
        if (i == 10) {
            return;
        }
        
        NSDictionary    *dic = imageArr[i];
        
        UIImageView *imageView = (UIImageView *)[mScrollerView viewWithTag:20+i];
        UILabel *movieNameLabel = (UILabel *)[mScrollerView viewWithTag:40+i];
        imageView.image = [dic objectForKey:@"img"];
        movieNameLabel.text = [dic objectForKey:@"content"];
        
    }
}
-(void)OnTapImage:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *)sender.view;
    int tag = (int)imageView.tag-80;
    [self.delegate didSelectedBtnWithIndex:tag];
}
@end
