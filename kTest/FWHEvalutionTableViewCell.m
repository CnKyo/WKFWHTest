//
//  FWHEvalutionTableViewCell.m
//  kTest
//
//  Created by wangke on 15/12/24.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHEvalutionTableViewCell.h"

@implementation FWHEvalutionTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
char* g_asskey = "g_asskey";
- (void)layoutSubviews{
    self.FWHContent.text = _model.mContent;
    self.FWHName.text = _model.mName;
    self.FWHTime.text = _model.mCreateTime;
    self.FWHStatus.text = _model.mResult;
    self.FWHServiceName.text = @"";
    if (_model.mResultId == 1) {
        self.FWHStatus.textColor = [UIColor colorWithRed:0.953 green:0.353 blue:0.553 alpha:1.000];
    }else if (_model.mResultId == 2){
        self.FWHStatus.textColor = [UIColor colorWithRed:0.933 green:0.553 blue:0.235 alpha:1.000];
    }else if (_model.mResultId == 3){
        self.FWHStatus.textColor = [UIColor colorWithRed:0.706 green:0.702 blue:0.706 alpha:1.000];
    }

    if ( _model.mImages.count ) {
        
        self.FWHImgView.hidden = NO;

        for (int o = 0; o < 3; o++) {
            UIImageView *img = (UIImageView *)[self.FWHImgView viewWithTag:o+1];
            img.image = nil;
        }
        for (int i = 0; i<3 && i < _model.mImages.count; i++) {
            
            NSString    *imgUrl = _model.mImages[i];
            UIImageView *img = (UIImageView *)[self.FWHImgView viewWithTag:i+1];
            [img sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"img_def"]];
            
            if ( !img.userInteractionEnabled ) {
                
                UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgAction:)];
                [img addGestureRecognizer:imgTap];
                img.userInteractionEnabled = YES;
                
                objc_setAssociatedObject(img, g_asskey, nil, OBJC_ASSOCIATION_ASSIGN);
                objc_setAssociatedObject(img, g_asskey, _model, OBJC_ASSOCIATION_ASSIGN);
            }
            
        }
        self.cellH = 225;
    }else{
        self.FWHImgView.hidden = YES;
        self.cellH = 145;

    }
    
}
- (void)imgAction:(UITapGestureRecognizer *)sender{
    UIImageView *image = (UIImageView *)sender.view;
    SSEvolution *SSE = objc_getAssociatedObject(image, g_asskey);
    
    NSMutableArray *mArr = [NSMutableArray new];
    
    for (NSString *urlStr in SSE.mImages) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:urlStr];
        photo.srcImageView = image;
        [mArr addObject:photo];
    }
    MJPhotoBrowser* browser = [[MJPhotoBrowser alloc]init];
    browser.currentPhotoIndex = image.tag+1;
    browser.photos  =  mArr;
    [browser show];
}
@end
