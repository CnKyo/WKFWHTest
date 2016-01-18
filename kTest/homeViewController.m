//
//  homeViewController.m
//  kTest
//
//  Created by wangke on 15/12/21.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "homeViewController.h"
#import "likeCell.h"
#import "normalTableViewCell.h"
#import "threeCell.h"
#import "tongyongCell.h"
#import "moreCell.h"
#import "homeTableViewCell.h"
#import "ViewController.h"
@interface homeViewController ()<UITableViewDataSource,UITableViewDelegate,mHeaderBtnSelected>

@end

@implementation homeViewController
{
    UITableView *mTableView;
    
    DCPicScrollView  *mHeaderView;
    
    NSMutableArray  *mTempArr;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar.leftBtn.hidden = YES;
    self.mPageName = self.Title = @"首页";
    [self setRightBtnTitle:@"右边"];
    
    mTempArr = [NSMutableArray new];
    [self loadData];
    
    
    [self initview];
}
- (void)loadData{
    
    UIImage *img = [UIImage imageNamed:@"defultHead"];
    NSString    *str = @"111";
    NSMutableDictionary    *dic = [NSMutableDictionary new];
    [dic setObject:img forKey:@"img"];
    [dic setObject:str forKey:@"content"];
    for (int i = 0; i<11; i++) {
        [mTempArr addObject:dic];
    }
    [mTableView reloadData];
}
- (void)initview{
    [self loadScrollerView];

    mTableView = [UITableView new];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.frame = CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-114);
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mTableView];
    

    UINib   *nib = [UINib nibWithNibName:@"normalTableViewCell" bundle:nil];
    ///有xib
//    [mTableView registerClass:[normalTableViewCell class] forCellReuseIdentifier:@"cell1"];
    [mTableView registerNib:nib forCellReuseIdentifier:@"cell1"];

    UINib   *nib2 = [UINib nibWithNibName:@"threeCell" bundle:nil];
    [mTableView registerNib:nib2 forCellReuseIdentifier:@"cell2"];
    
    UINib   *nib3 = [UINib nibWithNibName:@"tongyongCell" bundle:nil];
    [mTableView registerNib:nib3 forCellReuseIdentifier:@"cell3"];
    
    UINib   *nib4 = [UINib nibWithNibName:@"moreCell" bundle:nil];
    [mTableView registerNib:nib4 forCellReuseIdentifier:@"cell4"];
    
    UINib   *nib5 = [UINib nibWithNibName:@"homeTableViewCell" bundle:nil];
    [mTableView registerNib:nib5 forCellReuseIdentifier:@"cell5"];
    
    [mTableView setTableHeaderView:mHeaderView];

}
- (void)loadScrollerView{
   
    NSMutableArray *arr2 = [[NSMutableArray alloc] init];
    
    
    for (int i = 1; i < 6; i++) {
        [arr2 addObject:[NSString stringWithFormat:@"%d.jpg",i*111]];
    };

    
    //网络加载
    
    NSArray *UrlStringArray = @[@"http://p1.qqyou.com/pic/UploadPic/2013-3/19/2013031923222781617.jpg",
                                @"http://cdn.duitang.com/uploads/item/201409/27/20140927192649_NxVKT.thumb.700_0.png",
                                @"http://img4.duitang.com/uploads/item/201409/27/20140927192458_GcRxV.jpeg",
                                @"http://cdn.duitang.com/uploads/item/201304/20/20130420192413_TeRRP.thumb.700_0.jpeg"];

    NSArray *titleArray = [@"午夜寂寞 谁来陪我,唱一首动人的情歌.你问我说 快不快乐,唱情歌越唱越寂寞.谁明白我 想要什么,一瞬间释放的洒脱.灯光闪烁 不必啰嗦,我就是传说中的那个摇摆哥.我是摇摆哥 音乐会让我快乐,我是摇摆哥 我已忘掉了寂寞.我是摇摆哥 音乐会让我洒脱,我们一起唱这摇摆的歌" componentsSeparatedByString:@"."];
    
    
    //显示顺序和数组顺序一致
    //设置图片url数组,和滚动视图位置
    mHeaderView = [DCPicScrollView picScrollViewWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) WithImageUrls:arr2];
    
    //显示顺序和数组顺序一致
    //设置标题显示文本数组
    mHeaderView.titleData = titleArray;
    
    //占位图片,你可以在下载图片失败处修改占位图片
    mHeaderView.placeImage = [UIImage imageNamed:@"place.png"];
    
    //图片被点击事件,当前第几张图片被点击了,和数组顺序一致
    
    [mHeaderView setImageViewDidTapAtIndex:^(NSInteger index) {
        printf("第%zd张图片\n",index);
    }];
    
    //default is 2.0f,如果小于0.5不自动播放
    mHeaderView.AutoScrollDelay = 2.5f;
    //    picView.textColor = [UIColor redColor];

    
    //下载失败重复下载次数,默认不重复,
    [[DCWebImageManager shareManager] setDownloadImageRepeatCount:1];
    
    //图片下载失败会调用该block(如果设置了重复下载次数,则会在重复下载完后,假如还没下载成功,就会调用该block)
    //error错误信息
    //url下载失败的imageurl
    [[DCWebImageManager shareManager] setDownLoadImageError:^(NSError *error, NSString *url) {
        NSLog(@"%@",error);
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableviewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
//{
//    return 1;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        return 120;
    }else if(indexPath.row == 1){
        return 180;
    }else if(indexPath.row == 2){
        return 400;
    }else if(indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5){
        return 180;
    }else if(indexPath.row == 6){
        return 120;
    }else{
        return 260;
    }
    
    
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        ///没有xib
        static NSString *cellIdentifier = @"cell0";
        
        likeCell    *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[likeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier andFrame:CGRectMake(0, 0, DEVICE_Width, 120)];
        }
        cell.delegate = self;
        [cell setImageArr:mTempArr];
        return cell;
    }else if(indexPath.row == 1){
        static NSString *cellid = @"cell1";

        normalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        [cell.mTitleBtn addTarget:self action:@selector(secondSession:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mOneBtn addTarget:self action:@selector(secondSession:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mTwoBtn addTarget:self action:@selector(secondSession:) forControlEvents:UIControlEventTouchUpInside];
        [cell.mThreeBtn addTarget:self action:@selector(secondSession:) forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }else if(indexPath.row == 2){
        static NSString *cellid = @"cell2";
        threeCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        return cell;
    }else if(indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5){
        
        static NSString *cellid = @"cell3";
        tongyongCell   *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        return cell;
    }else if(indexPath.row == 6){
        static NSString *cellid = @"cell4";
        moreCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        return cell;
    }else{
        static NSString *cellid = @"cell5";
        homeTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)didSelectedBtnWithIndex:(NSInteger)index{
    lll(@"AlbumIndex:%ld",(long)index);
}
///第二块的按钮事件
- (void)secondSession:(UIButton *)sender{
    switch (sender.tag) {
        case 1:
        {
            lll(@"1");
        }
            break;
        case 2:
        {
            lll(@"2");

        }
            break;
        case 3:
        {
            lll(@"3");

        }
            break;
        case 4:
        {
            lll(@"4");

        }
            break;
        default:
            break;
    }
}

- (void)rightBtnAction:(id)sender{
    ViewController  *v = [ViewController new];
    [self pushViewController:v];
}
@end
