//
//  Model.m
//  kTest
//
//  Created by wangke on 16/1/6.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "Model.h"

@implementation Model



@end

@interface mBaseModel()

@property (strong,nonatomic) id mCoreData;

@end

@implementation mBaseModel

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    
    if (self && obj != nil) {
        
        self.mCoreData = obj;
        
        self.mCode = [[obj objectForMyKey:@"code"] intValue];
        self.mSucsess = self.mCode == 0;
        self.mMessege = [obj objectForMyKey:@"msg"];
        self.mDebug = [obj objectForMyKey:@"debug"];
        self.mData = [obj objectForMyKey:@"data"];
        
    }
    return self;
}
+ (mBaseModel *)infoWithError:(NSString *)error{
    mBaseModel  *obj  = mBaseModel.new;
    obj.mCode = 1;
    obj.mSucsess = NO;
    obj.mMessege = error;
    return obj;
}
@end

@interface mAppInfo ()

@end

static mAppInfo *mInfo = nil;

@implementation mAppInfo

-(id)initWithObj:(NSDictionary *)obj
{
    self = [super init];
    if( self && obj != nil )
    {
        self.mGToken = [obj objectForMyKey:@"token"];
        NSString* sssssss = [obj objectForMyKey:@"key"];
        if( sssssss.length )
        {
            char keyPtr[10]={0};
            [sssssss getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
            self.mIvint  = (int)strtoul(keyPtr,NULL,24);
        }
        
        NSDictionary* data = [obj objectForMyKey:@"data"];
        self.mAppVersion    = [data objectForMyKey:@"appVersion"];
        self.mAppDownLoadUrl    = [data objectForMyKey:@"appDownUrl"];
        self.mServicePhone    = [data objectForMyKey:@"serviceTel"];
        
        if(  [self.mAppVersion isEqualToString:[Util getAppVersion]] )
        {
            self.mAppDownLoadUrl = nil;
        }
        
    }
    return self;
}


+ (mAppInfo *)initAppInfo{
    if ( mInfo )
        return mInfo;
   
    @synchronized( self ) {
        
        if ( !mInfo ) {
             mAppInfo    *info = [mAppInfo loadAppInfo];
            if ( [info mAppInfoIsValid] ) {
                mInfo = info;
            }
        }
        return mInfo;
        
    }
}

static bool g_blocked = NO;
static bool g_startlooop = NO;
+ (void)getAppGinfo:(void (^)(mBaseModel *mData, mAppInfo *mInfo))block{
    if ( !g_startlooop ) {
        mAppInfo *appinfo = [mAppInfo initAppInfo];
        
        if ( appinfo ) {
            mBaseModel *model = [[mBaseModel alloc] init];
            model.mSucsess = YES;
            
            block ( model ,appinfo);
            g_blocked = YES;
        }
    }
    
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:DeviceType() forKey:@"systemInfo"];
    [para setObject:@"ios" forKey:@"deviceType"];
    [para setObject:DeviceSys() forKey:@"systemVersion"];
    [para setObject:[Util getAppVersion] forKey:@"appVersion"];
    [[HTTPRequest HttpRequest]postUrl:@"app.init" andParameters:para block:^(mBaseModel *dic) {
        if (dic.mSucsess) {
            ///如果网络获取成功,并且数据有效,就覆盖本地的
            
            mAppInfo *nInfo = [[mAppInfo alloc] initWithObj:dic.mCoreData];
            if ( [nInfo mAppInfoIsValid] ) {
                ///有效
                [mAppInfo saveAppInfo:dic.mCoreData];
                
                nInfo = [mAppInfo initAppInfo];
                
                if ( [nInfo mAppInfoIsValid]) {
                    if ( !g_blocked) {
                        g_blocked = YES;
                        
                        block ( dic,nInfo);
                    }
                    if (g_startlooop) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UserGinfoSuccess" object:nil];
                    }
                    return ;
                }
            }
        }else{
        
            mAppInfo *loca = [mAppInfo initAppInfo];
            
            if ( loca) {
                if (!g_blocked) {
                    g_blocked = YES;
                    block( dic,loca);
                }
            }else{
            
                if ( !g_blocked ) {
                    g_blocked = YES;
                    
                    block ( [mBaseModel infoWithError:@"获取配置信息失败"],nil);
                }
                [mAppInfo loopAppInfo];
            }
        }
    }];
}
+ (void)loopAppInfo{

    g_startlooop = YES;
    
    int64_t delayInSeconds = 1.0*20;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [mAppInfo getAppGinfo:^(mBaseModel *mData, mAppInfo *mInfo) {
            
        }];
        
    });
}

- (BOOL)mAppInfoIsValid{
    return self.mGToken.length > 0;
}
+ (mAppInfo *)loadAppInfo{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [def objectForKey:@"mAppInfo"];
    
    if (dic) {
        return [[mAppInfo alloc] initWithObj:dic];
    }
    return nil;
}
+ (void)saveAppInfo:(id)dic{

    dic = [Util delNUll:dic];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:dic forKey:@"mAppInfo"];
    [def synchronize];
}
@end

@interface mUser()

@property (strong,nonatomic) id mCoreData;

@end

@implementation mUser


static mUser *gUser = nil;
///返回当前用户
+ (mUser *)backNowUser{

    if ( gUser ) {
        return gUser;
    }
    @synchronized(self) {
        if ( !gUser ) {
            
            gUser = [mUser loadUserInfo];
        }
        return gUser;
    }
    
}

+ (void)saveUserInfo:(id)info{
    info = [Util delNUll:info];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:info forKey:@"userInfo"];
    [def synchronize];
}

+ (mUser *)loadUserInfo{
    NSUserDefaults  *def = [NSUserDefaults standardUserDefaults];
    NSDictionary    *dic = [def objectForKey:@"userInfo"];
    
    if ( dic ) {
        mUser *user = [[mUser alloc]initWithObj:dic];
        return user;
    }
    return nil;
    
}

+ (NSDictionary *)loadUserJson{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"userInfo"];
}
+ (void)cleanUserInfo{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"userInfo"];
    [def synchronize];
}
- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if (self && obj != nil) {
        
        [self fetchIt:obj];
    }
    return self;
}
- (void)fetchIt:(NSDictionary *)obj{
    NSDictionary *dic = [obj objectForMyKey:@"user"];
    _mUserId = [[[obj objectForMyKey:@"staff"] objectForMyKey:@"id"] intValue];
    _mUserName = [dic objectForMyKey:@"name"];
    _mUserPhone = [dic objectForMyKey:@"mobile"];
    _mUserImg = [[obj objectForMyKey:@"staff"] objectForMyKey:@"avatar"];
    _mToken = [obj objectForMyKey:@"token"];
    dic = [obj objectForMyKey:@"staff"];
    _mUserExpend = [[SSUserExpend alloc]initWithObj:[dic objectForKey:@"extend"]];;
}
///是否需要登录
+ (BOOL)isNeedLogin{
    return [mUser backNowUser] == nil;
}
///退出登录
+ (void)loginOut{
    [mUser cleanUserInfo];
    gUser = nil;
    
    [[HTTPRequest HttpRequest]postUrl:@"user.logout" andParameters:nil block:^(mBaseModel *dic) {
        
    }];
    [mUser closeTokenWithPush];
}
///发送短信
+ (void)sendMsgToPhone:(NSString *)mPhone block:(void (^)(mBaseModel *mData))block{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:mPhone forKey:@"mobile"];
    
    [[HTTPRequest HttpRequest]postUrl:@"user.mobileverify" andParameters:@"mobile" block:^(mBaseModel *dic) {
        block ( dic );
    }];
    
}
///验证码登录
+ (void)loginWithCode:(NSString *)mphone andCode:(NSString *)mCode block:(void (^)(mBaseModel *mData, mUser *mUser))block{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:mphone forKey:@"mobile"];
    [parameter setObject:mCode forKey:@"verifyCode"];
    
    [[HTTPRequest HttpRequest]postUrl:@"user.verifylogin" andParameters:parameter block:^(mBaseModel *dic) {
        
        if ( dic.mSucsess && dic.mData ) {
            NSDictionary    *tempDic = dic.mData;
#ifdef ENC
            
            NSMutableDictionary* tdic = [[NSMutableDictionary alloc]initWithDictionary:dic.mdata];
            NSString* fucktoken = [info.mcoredat objectForKeyMy:@"token"];
            if( fucktoken )
                [tdic setObject:fucktoken forKey:@"token"];
            mUser* tu = [[mUser alloc]initWithObj:tdic];
            tempDic = tdic;
            
#else
            
            mUser   *user = [[mUser alloc] initWithObj:dic.mData];
#endif
            
            if ( user ) {
                [mUser saveUserInfo:tempDic];

            }
            
        }
        block( dic ,[mUser backNowUser]);
    }];

}
///登录
+ (void)loginWithPhone:(NSString *)mPhone andPwd:(NSString *)mPwd block:(void (^)(mBaseModel *, mUser *))block{
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setObject:mPhone forKey:@"mobile"];
    [parameter setObject:mPwd forKey:@"pwd"];
    
    [[HTTPRequest HttpRequest]postUrl:@"user.login" andParameters:parameter block:^(mBaseModel *dic) {
        
        if (dic.mSucsess) {
            NSDictionary    *tempDic = dic.mData;
            
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc] initWithDictionary:dic.mData];
            NSString    *mToken = [dic.mCoreData objectForMyKey:@"token"];
            if ( mToken ) {
                [mDic setObject:mToken forKey:@"token"];
            }
            mUser   *user = [[mUser alloc]initWithObj:mDic];
            tempDic = mDic;
            
            if ( user ) {
                [mUser saveUserInfo:tempDic];
                [mUser openTokenWithPush];
            }
        }
        
        block ( dic ,[mUser backNowUser]);
    }];
    
}
///忘记密码
+ (void)forgetPwd:(NSString *)mPhone andNewPwd:(NSString *)mNewPwd andCode:(NSString *)mCode block:(void (^)(mBaseModel *, mUser *))block{

}

+ (void)resetInfo:(NSString *)mPhone andPwd:(NSString *)mPwd andCode:(NSString *)mCode block:(void(^)(mBaseModel *mData,mUser *mUser))block{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:mPhone forKey:@"mobile"];
    [param setObject:mPwd forKey:@"pwd"];
    [param setObject:mCode forKey:@"verifyCode"];
    [param setObject:@"repwd" forKey:@"type"];
    
    [[HTTPRequest HttpRequest]postUrl:@"" andParameters:param block:^(mBaseModel *dic) {
        if (dic.mSucsess) {
            NSDictionary *tempDic = dic.mData;
            
            NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:dic.mData];
            
            NSString    *mToken = [dic.mCoreData objectForMyKey:@"token"];
            
            if ( mToken ) {
                [mDic setObject:mToken forKey:@"token"];
                
            }
            mUser   *user = [[mUser alloc]initWithObj:mDic];
            tempDic = mDic;
            
            if ( user ) {
                [mUser openTokenWithPush];
                [mUser saveUserInfo:tempDic];
                
            }
        }
        block ( dic ,[mUser backNowUser]);
    }];
}

+ (void)closeTokenWithPush{
    [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
}
+ (void)openTokenWithPush{
    NSString    *str = [NSString stringWithFormat:@"%d",[mUser backNowUser].mUserId];
    if (str.length == 0) {
        str = @"";
    }
    str = [@"staff_" stringByAppendingString:str];
    
    NSSet *setAlias = [[NSSet alloc]initWithObjects:@"staff", @"ios", nil];
    [APService setTags:setAlias alias:str callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:[UIApplication sharedApplication].delegate];
}

- (void)getOrderList:(int)mPage andStatus:(int)mStattus block:(void(^)(mBaseModel *mData,NSArray *mArray))block{

    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mStattus) forKey:@"status"];
    [para setObject:NumberWithInt(mPage) forKey:@"page"];
    [[HTTPRequest HttpRequest]postUrl:@"order.lists" andParameters:para block:^(mBaseModel *dic) {
        
        NSArray *arr = nil;
        
        if (dic.mSucsess) {
            
            NSMutableArray  *temparr = [NSMutableArray new];
            
            for (NSDictionary *tempdic in dic.mData) {
                
                [temparr addObject:[[SSOrder alloc] initWithObj:tempdic]];
            }
            arr = temparr;
        }
        
        block ( dic ,arr);
    }];
}
- (void)getStatisic:(int)mYear andMonth:(int)mMonth andPage:(int)mPage block:(void (^)(mBaseModel *, NSArray *))block{
    if ( mMonth == -1 ) {
        NSMutableDictionary *para = [NSMutableDictionary new];
        [para setObject:NumberWithInt(mPage) forKey:@"page"];
        [[HTTPRequest HttpRequest]postUrl:@"statistics.month" andParameters:para block:^(mBaseModel *dic) {
            NSArray  *arr = nil;
            
            if (dic.mSucsess) {
                
                NSMutableArray *marr = [NSMutableArray new];
                for (NSDictionary *tempdic in dic.mData) {
                    SStatistical    *ss = [[SStatistical alloc] initWithObj:tempdic];
                    [marr addObject:ss];
                }
                arr = marr;
            }
            block ( dic,arr);
        }];
    }else{
        NSMutableDictionary *para = [NSMutableDictionary new];
        [para setObject:NumberWithInt(mMonth) forKey:@"month"];
        [para setObject:NumberWithInt(mPage) forKey:@"page"];
        if (mMonth > 0) {
            if (mMonth < 10) {
                [para setObject:[NSString stringWithFormat:@"%d0%d",mYear,mMonth] forKey:@"month"];
            }else{
                [para setObject:[NSString stringWithFormat:@"%d%d",mYear,mMonth] forKey:@"month"];
            }
        }
        [[HTTPRequest HttpRequest]postUrl:@"statistics.detail" andParameters:para block:^(mBaseModel *dic) {
            
            NSArray  *arr = nil;
            
            if (dic.mSucsess) {
                
                NSMutableArray *marr = [NSMutableArray new];
                for (NSDictionary *tempdic in dic.mData) {
                    SStatistical    *ss = [[SStatistical alloc] initWithObj:tempdic];
                    [marr addObject:ss];
                }
                arr = marr;
            }
            block ( dic,arr);
        }];
    }
}
- (void)getEvaluationList:(int)mType andPage:(int)mPage block:(void (^)(mBaseModel *, NSArray *))block{
    NSMutableDictionary     *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mType) forKey:@"type"];
    [para setObject:NumberWithInt(mPage) forKey:@"page"];
    [[HTTPRequest HttpRequest]postUrl:@"rate.staff.lists" andParameters:para block:^(mBaseModel *dic) {
        
        NSArray *marr = nil;

        if (dic.mSucsess) {
            
            NSMutableArray *tempArr = [NSMutableArray new];

            for (NSDictionary *tempDic in dic.mData) {
                SSEvolution *SSE = [[SSEvolution alloc]initWithObj:tempDic];
                [tempArr addObject:SSE];
            }
            marr = tempArr;
        }
        
        block ( dic,marr);
        
    }];
}
- (void)getDateList:(void (^)(mBaseModel *, NSArray *))block{
    [[HTTPRequest HttpRequest] postUrl:@"schedule.lists" andParameters:nil block:^(mBaseModel *dic) {
        
        NSArray *tempArr = nil;
        NSMutableArray  *arrtemp = [NSMutableArray new];
        if (dic.mSucsess) {
            
            for (NSDictionary *tempDic in dic.mData) {
                SSDate *ssd = [[SSDate alloc] initWithObj:tempDic];
                [arrtemp addObject:ssd];
            }
            tempArr = arrtemp;
        }
        
        block ( dic , tempArr );
    }];
}
- (void)getMessageList:(int)mPage block:(void (^)(mBaseModel *, NSArray *))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(mPage) forKey:@"page"];
    [[HTTPRequest HttpRequest] postUrl:@"msg.lists" andParameters:para block:^(mBaseModel *dic) {
        
        NSArray *arrtemp = nil;
        NSMutableArray  *tempArr = [NSMutableArray new];
        if (dic.mSucsess) {
            
            for (NSDictionary *tempdic in dic.mData) {
                
                [tempArr addObject:[[SSMessage alloc] initWithObj:tempdic]];
            }
            
            arrtemp = tempArr;
        }
        
        block ( dic , arrtemp );
        
    }];
}
@end

@implementation SSUserExpend

- (id)initWithObj:(NSDictionary *)obj{

    self = [super init];
    if ( self ) {
        
        self.mGoodsAvgPrice = [[obj objectForMyKey:@"goodsAvgPrice"] floatValue];
        self.mOrderCount = [[obj objectForMyKey:@"orderCount"] intValue];
        self.mCommentTotalCount = [[obj objectForMyKey:@"commentTotalCount"] intValue];
        self.mCommentGoodCount = [[obj objectForMyKey:@"commentGoodCount"] intValue];
        self.mCommentNeutralCount = [[obj objectForMyKey:@"commentNeutralCount"] intValue];
        self.mCommentBadCount = [[obj objectForMyKey:@"commentBadCount"] intValue];
        self.mCommentSpecialtyAvgScore = [[obj objectForMyKey:@"commentSpecialtyAvgScore"] floatValue];
        self.mCommentCommunicateAvgScore = [[obj objectForMyKey:@"commentCommunicateAvgScore"] floatValue];
        self.mCommentPunctualityAvgScore = [[obj objectForMyKey:@"commentPunctualityAvgScore"] floatValue];
        
    }
    return self;
}

@end

@implementation SSOrder

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if ( self && obj != nil ) {
//        self.mSn = [obj objectForMyKey:@"sn"];
//        self.mAddress = [obj objectForMyKey:@"address"];
//        self.mCreatOrderTime = [[obj objectForMyKey:@"createTime"] intValue];
        self.mServiceName = [obj objectForMyKey:@"goodsName"];
//        self.mPrice = [obj objectForMyKey:@"totalFee"];
//        self.mName = [obj objectForMyKey:@"userName"];
//        self.mOrderId = [[obj objectForMyKey:@"id"] intValue];
//        self.mPhone = [obj objectForMyKey:@"mobile"];
        
        self.mSn= [obj objectForMyKey:@"sn"]                ;//订单号
        self.mId= [[obj objectForMyKey:@"id"] intValue]                 ;//编号
        int second = [[obj objectForMyKey:@"createTime"] intValue];
        self.mApptime= [Util getTimeStringHourSecond:second];//当初预约的时间
        self.mPromStr= [[obj objectForMyKey:@"promotion"] objectForMyKey:@"promotionName"]                  ;//优惠描述
        self.mPromMoney= [[obj objectForMyKey:@"discountFee"] floatValue]                ;//优惠了多少钱
        self.mUserName=  [obj objectForMyKey:@"userName"]                ;//下单的人
        self.mPhoneNum= [obj objectForMyKey:@"mobile"]                 ;//下单的电话
        self.mAddress= [obj objectForMyKey:@"address"]                 ;//地址
        self.mTotalMoney= [[obj objectForMyKey:@"totalFee"] floatValue]                 ;//总价
        self.mPayMoney= [[obj objectForMyKey:@"payFee"] floatValue]                 ;//支付金额
        self.mReMark= [obj objectForMyKey:@"buyRemark"]                 ;//备注
        self.mOrderStateStr = [obj objectForMyKey:@"orderStatusStr"];
        self.mServiceScope = [obj objectForMyKey:@"serviceScope"];
        self.mServiceBrief = [[obj objectForMyKey:@"goods"]objectForMyKey:@"brief"];///服务内容
        
        self.mServiceImgUrl = [[obj objectForMyKey:@"goods"] objectForMyKey:@"image"];
        self.mServiceDuration = [[[obj objectForMyKey:@"goods"] objectForMyKey:@"duration"] intValue];
        
        _mLongit =[[[obj objectForMyKey:@"mapPoint"] objectForKey:@"y"] floatValue];
        _mLat =[[[obj objectForMyKey:@"mapPoint"] objectForKey:@"x"] floatValue];
        
        _mServiceStartTime = [[obj objectForMyKey:@"serviceStartTime"] intValue];
        _mServiceFinishTime = [[obj objectForMyKey:@"serviceFinishTime"]intValue];
        
        second = [[obj objectForMyKey:@"appointTime"] intValue];
        self.mCreateOrderTime =[Util getTimeStringHourSecond:second];
        
        self.mCreateOrderTimeWithWeek = self.mCreateOrderTime;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSInteger unitFlags = NSWeekdayCalendarUnit;
        
        NSDateComponents *comps = [calendar components:unitFlags fromDate:[Util dateWithInt:second]];
        NSInteger wkd = [comps weekday];
        
        NSString* wdkstr = @"";
        switch (wkd) {
            case 1:
                wdkstr = @"(周日) ";
                break;
            case 2:
                wdkstr = @"(周一) ";
                break;
            case 3:
                wdkstr = @"(周二) ";
                break;
            case 4:
                wdkstr = @"(周三) ";
                break;
            case 5:
                wdkstr = @"(周四) ";
                break;
            case 6:
                wdkstr = @"(周五) ";
                break;
            case 7:
                wdkstr = @"(周六) ";
                break;
            default:
                break;
        }
        
        self.mCreateOrderTimeWithWeek = [self.mCreateOrderTimeWithWeek stringByReplacingOccurrencesOfString:@" " withString:wdkstr];
        

        
    }
    return self;
}
- (void)fetchObj:(NSDictionary *)obj{
    //        self.mSn = [obj objectForMyKey:@"sn"];
    //        self.mAddress = [obj objectForMyKey:@"address"];
    //        self.mCreatOrderTime = [[obj objectForMyKey:@"createTime"] intValue];
    self.mServiceName = [obj objectForMyKey:@"goodsName"];
    //        self.mPrice = [obj objectForMyKey:@"totalFee"];
    //        self.mName = [obj objectForMyKey:@"userName"];
    //        self.mOrderId = [[obj objectForMyKey:@"id"] intValue];
    //        self.mPhone = [obj objectForMyKey:@"mobile"];
    
    self.mSn= [obj objectForMyKey:@"sn"]                ;//订单号
    self.mId= [[obj objectForMyKey:@"id"] intValue]                 ;//编号
    int second = [[obj objectForMyKey:@"createTime"] intValue];
    self.mApptime= [Util getTimeStringHourSecond:second];//当初预约的时间
    self.mPromStr= [[obj objectForMyKey:@"promotion"] objectForMyKey:@"promotionName"]                  ;//优惠描述
    self.mPromMoney= [[obj objectForMyKey:@"discountFee"] floatValue]                ;//优惠了多少钱
    self.mUserName=  [obj objectForMyKey:@"userName"]                ;//下单的人
    self.mPhoneNum= [obj objectForMyKey:@"mobile"]                 ;//下单的电话
    self.mAddress= [obj objectForMyKey:@"address"]                 ;//地址
    self.mTotalMoney= [[obj objectForMyKey:@"totalFee"] floatValue]                 ;//总价
    self.mPayMoney= [[obj objectForMyKey:@"payFee"] floatValue]                 ;//支付金额
    self.mReMark= [obj objectForMyKey:@"buyRemark"]                 ;//备注
    self.mOrderStateStr = [obj objectForMyKey:@"orderStatusStr"];
    self.mServiceScope = [obj objectForMyKey:@"serviceScope"];
    self.mServiceBrief = [[obj objectForMyKey:@"goods"]objectForMyKey:@"brief"];///服务内容
    
    self.mServiceImgUrl = [[obj objectForMyKey:@"goods"] objectForMyKey:@"image"];
    self.mServiceDuration = [[[obj objectForMyKey:@"goods"] objectForMyKey:@"duration"] intValue];
    
    _mLongit =[[[obj objectForMyKey:@"mapPoint"] objectForKey:@"y"] floatValue];
    _mLat =[[[obj objectForMyKey:@"mapPoint"] objectForKey:@"x"] floatValue];
    
    _mServiceStartTime = [[obj objectForMyKey:@"serviceStartTime"] intValue];
    _mServiceFinishTime = [[obj objectForMyKey:@"serviceFinishTime"]intValue];
    
    second = [[obj objectForMyKey:@"appointTime"] intValue];
    self.mCreateOrderTime =[Util getTimeStringHourSecond:second];
    
    self.mCreateOrderTimeWithWeek = self.mCreateOrderTime;
    
    self.mOrderState = [[obj objectForMyKey:@"orderStatus"] intValue];
    self.mPayState = [[obj objectForMyKey:@"payStatus"] intValue];
    self.mBComment= [[obj objectForMyKey:@"isRate"] boolValue]                 ;//是否已经评价过了

    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[Util dateWithInt:second]];
    NSInteger wkd = [comps weekday];
    
    NSString* wdkstr = @"";
    switch (wkd) {
        case 1:
            wdkstr = @"(周日) ";
            break;
        case 2:
            wdkstr = @"(周一) ";
            break;
        case 3:
            wdkstr = @"(周二) ";
            break;
        case 4:
            wdkstr = @"(周三) ";
            break;
        case 5:
            wdkstr = @"(周四) ";
            break;
        case 6:
            wdkstr = @"(周五) ";
            break;
        case 7:
            wdkstr = @"(周六) ";
            break;
        default:
            break;
    }
    
    self.mCreateOrderTimeWithWeek = [self.mCreateOrderTimeWithWeek stringByReplacingOccurrencesOfString:@" " withString:wdkstr];
    
}
-(BOOL)isPayed
{
    return _mPayState == 1;
}
-(BOOL)isCommented
{
    return _mBComment;
}
- (UIShowBt)getUIShowbt{

    if( _mOrderState == E_OS_WaitSeller && [self isPayed] )
    {
        return E_UIShow_StartSrv;
    }
    else if( _mOrderState == E_OS_SRVing )
    {
        return E_UIShow_CompleteSrv;
    }
    
    lll(@"what fuck state!");
    return E_UIShow_NON;
}
- (void)getOrderDetail:(void (^)(mBaseModel *))block{
    NSMutableDictionary* param =    NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [[HTTPRequest HttpRequest]postUrl:@"order.detail" andParameters:param block:^(mBaseModel *dic) {
        if (dic.mSucsess) {
            [self fetchObj:dic.mData];
        }
        block ( dic );
    }];
}
- (void)updateService:(int)mStatus andBlock:(void(^)(mBaseModel *mData))block{
    NSMutableDictionary *para = [NSMutableDictionary new];
    [para setObject:NumberWithInt(_mId) forKey:@"orderId"];
    [para setObject:NumberWithInt(mStatus) forKey:@"status"];
    [[HTTPRequest HttpRequest]postUrl:@"order.updatestatus" andParameters:para block:^(mBaseModel *dic) {
        
        if (dic.mSucsess) {
            [self fetchObj:dic.mData];
        }
        
        block ( dic );
        
    }];
    
}

@end

@implementation SStatistical

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if (self && obj != nil) {

        NSString* tt = [obj objectForMyKey:@"month"];
        if( tt.length == 6 )
        {
            self.mMonth = [[tt substringFromIndex:4] intValue];
            self.mYear = [[tt substringToIndex:4] intValue];
        }
        self.mNum = [[obj objectForMyKey:@"num"] intValue];
       
        
        SSOrder* or = [[SSOrder alloc]initWithObj: obj];
        self.mImgURL = [[obj objectForMyKey:@"goods"] objectForMyKey:@"image"];
        self.mSrvName = [[obj objectForMyKey:@"goods"] objectForMyKey:@"name"];
        self.mTimeStr = [or.mCreateOrderTime copy];
        self.mTotal = or.mTotalMoney;
        self.mOrderId = or.mId;
    }
    return self;
}

@end

@implementation SSEvolution

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if ( self ) {
        
        self.mCommunicateScore = [[obj objectForMyKey:@"communicateScore"] intValue];
        self.mContent = [obj objectForMyKey:@"content"];
        NSDate *date = [Util dateWithInt: [[obj objectForMyKey:@"createTime"] intValue]];
        self.mCreateTime = [Util FormartTime:date];
        self.mGoodsId = [[obj objectForMyKey:@"goodsId"] intValue];
        self.mId = [[obj objectForMyKey:@"id"] intValue];
        self.mOrderId = [[obj objectForMyKey:@"orderId"] intValue];
        self.mPunctualityScore = [[obj objectForMyKey:@"punctualityScore"] intValue];
        self.mReply = [obj objectForMyKey:@"reply"];
        self.mScore = [[obj objectForMyKey:@"score"] intValue];
        self.mSpecialtyScore = [[obj objectForMyKey:@"specialtyScore"] intValue];
        self.mAvatar = [[obj objectForMyKey:@"user"] objectForMyKey:@"avatar"];
        self.mUserId = [[[obj objectForMyKey:@"user"] objectForMyKey:@"id"] intValue];
        self.mMobile = [[obj objectForMyKey:@"user"] objectForMyKey:@"mobile"];
        self.mName = [[obj objectForMyKey:@"user"] objectForMyKey:@"name"];

        
        NSArray *tempArr = [obj objectForMyKey:@"images"];
        
        NSMutableArray *arrtemp = [NSMutableArray new];
        
        for ( NSString *str in tempArr ) {
            if (str.length == 0) {
                continue;
            }
            [arrtemp addObject:[str stringByAppendingString:@"@130w_130h_1e_1c_1o.jpg"]];
            
        }
        self.mImages = arrtemp;
        
        NSString    *result = [obj objectForMyKey:@"result"];

        if ([result isEqualToString:@"good"]) {
            self.mResult = @"好评";
            self.mResultId = 1;
        }else if ([result isEqualToString:@"neutral"]){
            self.mResult = @"中评";
            self.mResultId = 2;
        }else if ([result isEqualToString:@"bad"]){
            self.mResult = @"差评";
            self.mResultId = 3;
        }
        
    }
    return self;
}

@end
@implementation SScheduleItem

-(id)initWithObj:(NSDictionary*)obj
{
    self = [super init];
    if( self )
    {
        self.mTimeStr   = [obj objectForMyKey:@"hour"];
        self.mStatus    = [[obj objectForMyKey:@"status"] intValue];
        if( _mStatus == 0 )//0：暂无安排 1：有单子 2：停止接单"
        {
            self.mStr = @"暂无安排";
            self.mbStringInfo = YES;
        }
        else if( _mStatus ==  -1 )
        {
            self.mStr = @"停止接单";
            self.mbStringInfo = YES;
        }
        else if( _mStatus == 1 )
        {
            self.mbStringInfo = NO;
            
            self.mAddress = [obj objectForMyKey:@"address"];
            self.mPhone = [obj objectForMyKey:@"mobile"];
            self.mSrvName = [obj objectForMyKey:@"goodName"];
            self.mUserName = [obj objectForMyKey:@"userName"];
            
            self.mOrder = SSOrder.new;
            self.mOrder.mId = [[obj objectForMyKey:@"orderId"] intValue];
            
        }
        else
        {
            self.mStr = @"未知安排";
            self.mbStringInfo = YES;
        }
    }
    return self;
}

@end
@implementation SSDate

- (id)initWithObj:(NSDictionary *)obj{
    self = [super init];
    if (self && obj != nil) {
        self.mDateStr = [obj objectForMyKey:@"day"];
        
        self.mStringDate = [Util convdatestr:_mDateStr];
        
        self.mWeek = [obj objectForMyKey:@"week"];
        
        NSArray* arrtemp = [obj objectForMyKey:@"hour"];
        NSMutableArray* tempArr = NSMutableArray.new;
        for ( NSDictionary *dic in arrtemp ) {
      
            SScheduleItem   *item = [[SScheduleItem alloc]initWithObj:dic];
            [tempArr addObject:item];
        }
        self.mList = tempArr;
    }
    return self;
}

@end
@implementation SSMessage

- (id)initWithObj:(NSDictionary *)obj{
    
    self = [super init];
    if (self) {
        
        self.mArgs = [obj objectForMyKey:@"args"];
        self.mContent = [obj objectForMyKey:@"content"];
        self.mId = [[obj objectForMyKey:@"id"] intValue];
        int time = [[obj objectForMyKey:@"sendTime"] intValue];
        self.mSendTime = [Util DateTimeInt:time];
        
        self.mStatus = [[obj objectForMyKey:@"status"] intValue];
        self.mTitle = [obj objectForMyKey:@"title"];
        self.mType = [[obj objectForMyKey:@"type"] intValue];
        
        self.mRead = [[obj objectForMyKey:@"status"] intValue];

        
    }
    return self;
}

- (void)MsgRead{
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(_mId) forKey:@"id"];
    [[HTTPRequest HttpRequest] postUrl:@"msg.read" andParameters:param block:^(mBaseModel *dic) {
        self.mRead = dic.mSucsess ? YES :self.mRead;
    }];

}
+ (void)readAll:(void (^)(mBaseModel *))block{
    
    NSMutableDictionary* param = NSMutableDictionary.new;
    [param setObject:NumberWithInt(0) forKey:@"id"];
    [[HTTPRequest HttpRequest]postUrl:@"msg.read" andParameters:param block:^(mBaseModel *dic) {

        
        block( dic );
        
        
    }];
}
@end