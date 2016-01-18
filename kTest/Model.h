//
//  Model.h
//  kTest
//
//  Created by wangke on 16/1/6.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@end

///所有接口返回基本的数据类型
@interface mBaseModel : NSObject
///是否成功
@property (nonatomic,assign) BOOL   mSucsess;
///接口号
@property (nonatomic,assign) int    mCode;
///返回信息
@property (strong,nonatomic) NSString   *mMessege;
///调试信息
@property (strong,nonatomic) NSString   *mDebug;
///数据
@property (strong,nonatomic) id         mData;

- (id)initWithObj:(NSDictionary *)obj;
///错误信息
+ (mBaseModel *)infoWithError:(NSString *)error;

@end
///程序的全局信息
@interface mAppInfo : NSObject
///全局token
@property (strong,nonatomic) NSString   *mGToken;
///
@property (nonatomic,assign) int    mIvint;
///版本号
@property (strong,nonatomic) NSString   *mAppVersion;
///更新app下载地址
@property (strong,nonatomic) NSString   *mAppDownLoadUrl;
///服务电话
@property (strong,nonatomic) NSString   *mServicePhone;
///初始化信息接口
+ (mAppInfo *)initAppInfo;

+ (void)getAppGinfo:(void(^)(mBaseModel *mData,mAppInfo *mInfo))block;

@end
@class SStatistical;
@class SSUserExpend;
@class SSEvolution;
///用户信息类
@interface mUser : NSObject
///用户id
@property (nonatomic,assign) int    mUserId;
///用户电话
@property (strong,nonatomic) NSString   *mUserPhone;
///用户名
@property (strong,nonatomic) NSString   *mUserName;
///用户头像
@property (strong,nonatomic) NSString   *mUserImg;
///用户的token
@property (strong,nonatomic) NSString   *mToken;
///城市
@property (strong,nonatomic) NSString   *mCity;
///扩展信息
@property (strong,nonatomic) SSUserExpend   *mUserExpend;

///返回当前用户
+ (mUser *)backNowUser;
///是否需要登录
+ (BOOL)isNeedLogin;
///退出登录
+ (void)loginOut;
///发送验证码
+ (void)sendMsgToPhone:(NSString *)mPhone block:(void(^)(mBaseModel *mData))block;
///密码登录
+ (void)loginWithPhone:(NSString *)mPhone andPwd:(NSString *)mPwd block:(void(^)(mBaseModel *mData,mUser *mUser))block;
///验证码登录
+ (void)loginWithCode:(NSString *)mphone andCode:(NSString *)mCode block:(void(^)(mBaseModel *mData,mUser *mUser))block;
///忘记密码／修改密码
+ (void)forgetPwd:(NSString *)mPhone andNewPwd:(NSString *)mNewPwd andCode:(NSString *)mCode block:(void(^)(mBaseModel *mData,mUser *mUser))block;
///修改用户的信息
- (void)upDateUserInfo:(NSString *)mName andUserImg:(UIImage *)mImg block:(void(^)(mBaseModel *mData,BOOL mSucsess,float value))block;
///获取订单列表
- (void)getOrderList:(int)mPage andStatus:(int)mStatus block:(void(^)(mBaseModel *mData,NSArray *mArray))block;

///获取统计列表
- (void)getStatisic:(int)mYear andMonth:(int)mMonth andPage:(int)mPage block:(void(^)(mBaseModel *mData,NSArray *mArray))block;
///获取评价列表
- (void)getEvaluationList:(int)mType andPage:(int)mPage block:(void(^)(mBaseModel *mData,NSArray *mArray))block;
///获取日程
- (void)getDateList:(void(^)(mBaseModel *mData,NSArray *mArray))block;
///获取消息
- (void)getMessageList:(int)mPage block:(void(^)(mBaseModel *mData,NSArray *mArray))block;
///关闭推送
+ (void)closeTokenWithPush;
///打开推送
+ (void)openTokenWithPush;
@end
///扩展信息
@interface SSUserExpend : NSObject
- (id)initWithObj:(NSDictionary *)obj;
@property (nonatomic,assign)    float       mGoodsAvgPrice;	//			卖家商品均价
@property (nonatomic,assign)    int         mOrderCount;	//			接单数量
@property (nonatomic,strong)    NSString*   mCreditRank;	//			信誉等级
@property (nonatomic,assign)    int         mCommentTotalCount;	//			评价总次数
@property (nonatomic,assign)    int         mCommentGoodCount;  //			评价好评数
@property (nonatomic,assign)    int         mCommentNeutralCount;	//			评价中评数
@property (nonatomic,assign)    int         mCommentBadCount;	//			评价差评数
@property (nonatomic,assign)    float       mCommentSpecialtyAvgScore;	//		评价专业平均分
@property (nonatomic,assign)    float       mCommentCommunicateAvgScore;   //          评价沟通平均分
@property (nonatomic,assign)    float       mCommentPunctualityAvgScore;	//			评价守时平均分

@end

typedef enum _orderState
{
    
    E_OS_WaitPay    = 0,//      "0：等待支付
    E_OS_Cacle      = 1,//      1：已取消
    E_OS_WaitSeller = 2,//      2：等待服务
    E_OS_SellerOut  = 3,//    3：服务人员已出发
    E_OS_SRVing     = 4,//       4：服务进行中
    E_OS_WaitConfim = 5,//      5：待确认
    E_OS_WaitComment= 6,//      6：待评价
    E_OS_SRVComplete= 7,//   7：服务完成"
    
}OrderState;

typedef enum _UIShowBt
{
    E_UIShow_NON            = 0,//无
    E_UIShow_Cancle_Pay     = 1,//取消订单 , 去支付
    E_UIShow_Cancle_ConTa   = 2,//取消订单 , 联系TA
    E_UIShow_ConTa_ConKf    = 3,//联系TA  , 联系客服
    E_UIShow_ConKf          = 4,//联系客服
    E_UIShow_Confim         = 5,//确认完成
    E_UIShow_Comment        = 6,//去评价
    E_UIShow_Del            = 7,//删除订单
    E_UIShow_Del_ConKf      = 8,//删除订单,联系客服
    E_UIShow_StartSrv       = 9,//卖家版本,显示开始服务
    E_UIShow_CompleteSrv    = 10,//卖家版本,显示完成服务
    
}UIShowBt;

@interface SSOrder : NSObject
- (id)initWithObj:(NSDictionary *)obj;

//@property (nonatomic,assign) int    mOrderId;
/////下单时间
//@property (nonatomic,assign) int mCreatOrderTime;
///服务名称
@property (strong, nonatomic)  NSString *mServiceName;
/////订单编号
//@property (strong, nonatomic)  NSString *mSn;
/////姓名
//@property (strong, nonatomic)  NSString *mName;
/////电话
//@property (strong, nonatomic)  NSString *mPhone;
/////地址
//@property (strong, nonatomic)  NSString *mAddress;
/////支付方式
//@property (strong, nonatomic)  NSString *mPayType;
/////价格
//@property (strong, nonatomic)  NSString *mPrice;

@property (nonatomic,strong)    NSString*       mSn;//订单号
@property (nonatomic,assign)    int             mId;//编号

@property (nonatomic,strong)    NSString*       mApptime;//当初预约的时间
@property (nonatomic,strong)    NSString*       mPromStr;//优惠描述
@property (nonatomic,assign)    float           mPromMoney;//优惠了多少钱
@property (nonatomic,strong)    NSString*       mUserName;//下单的人
@property (nonatomic,strong)    NSString*       mPhoneNum;//下单的电话
@property (nonatomic,strong)    NSString*       mAddress;//地址
@property (nonatomic,assign)    float           mTotalMoney;//总价
@property (nonatomic,assign)    float           mPayMoney;//支付金额
@property (nonatomic,strong)    NSString*       mReMark;//备注
@property (nonatomic,strong)    NSString*       mOrderStateStr;//订单状态字符串格式
@property (nonatomic,strong)    NSString*       mCreateOrderTime;//下单时间
@property (nonatomic,strong)    NSString*       mCreateOrderTimeWithWeek;//下单时间
@property (nonatomic,strong)    NSString*       mServiceScope;//
///服务简介/内容
@property (nonatomic,strong)    NSString*       mServiceBrief;
@property (nonatomic,assign)    int      mOrderState;
@property (nonatomic,assign)    int             mPayState;//0 没有支付,1已经支付
@property (nonatomic,assign)    BOOL            mBComment;//是否已经评价过了

@property (nonatomic,assign)    float           mLongit;
@property (nonatomic,assign)    float           mLat;
///服务图片地址
@property (nonatomic,strong)    NSString*       mServiceImgUrl;
///服务时长
@property (nonatomic,assign)    int             mServiceDuration;

///服务开始时间
@property (nonatomic,assign)    int             mServiceStartTime;
///服务完成时间
@property (nonatomic,assign)    int             mServiceFinishTime;

///获取订单详情
- (void)getOrderDetail:(void(^)(mBaseModel *mData))block;

///获取按钮显示情况
-(UIShowBt)getUIShowbt;

///更新服务
- (void)updateService:(int)mStatus andBlock:(void(^)(mBaseModel *mData))block;

@end

@interface SStatistical : NSObject

- (id)initWithObj:(NSDictionary *)obj;
///年
@property (nonatomic,assign) int        mYear;
///月
@property (nonatomic,assign) int        mMonth;
///总数
@property (nonatomic,assign) int        mNum;
///总价
@property (nonatomic,assign) float      mTotal;
///订单id
@property (nonatomic,assign) int        mOrderId;

///详情列表的时候,需要下面的
@property (nonatomic,strong) NSString*  mTimeStr;
///服务名称
@property (nonatomic,strong) NSString*  mSrvName;
///图片
@property (nonatomic,strong) NSString*  mImgURL;

@end

@interface SSEvolution : NSObject

- (id)initWithObj:(NSDictionary *)obj;

@property (nonatomic,assign) int        mCommunicateScore;
@property (nonatomic,assign) int        mGoodsId;
@property (nonatomic,assign) int        mOrderId;
@property (nonatomic,assign) int        mId;
@property (nonatomic,assign) int        mPunctualityScore;
@property (nonatomic,assign) int        mScore;
@property (nonatomic,assign) int        mSpecialtyScore;
@property (nonatomic,assign) int        mUserId;

@property (nonatomic,assign) int        mResultId;

@property (nonatomic,strong) NSString*  mContent;
@property (nonatomic,strong) NSString*  mCreateTime;
@property (nonatomic,strong) NSString*  mResult;
@property (nonatomic,strong) NSString*  mAvatar;
@property (nonatomic,strong) NSString*  mName;
@property (nonatomic,strong) NSString*  mMobile;
@property (nonatomic,strong) NSString*  mReply;

@property (nonatomic,strong) NSArray*  mImages;

@end

@interface SScheduleItem : NSObject


@property (nonatomic,strong)    NSString*   mTimeStr;//10:00 ...
@property (nonatomic,assign)    BOOL        mbStringInfo;//mStringInfo = NO表示是简要订单数据
@property (nonatomic,strong)    NSString*   mStr;//mStringInfo = YES 显示这个

//mbStringInfo = NO才有下面的
@property (nonatomic,strong)    NSString*   mSrvName;//服务名字
@property (nonatomic,strong)    NSString*   mUserName;//买家名称
@property (nonatomic,strong)    NSString*   mPhone;//买家手机号
@property (nonatomic,strong)    NSString*   mAddress;//buyer address;
@property (nonatomic,strong)    SSOrder*     mOrder;//mbStringInfo  =NO 表示一个订单数据,点击跳转到订单详情

@property (nonatomic,strong)    NSString*   mDateStr;
@property (nonatomic,assign)    int         mStatus;//"0：暂无安排 1：有单子 -1：停止接单"

@property (nonatomic,assign)    BOOL        mChecked;

@end


@interface SSDate : NSObject

- (id)initWithObj:(NSDictionary *)obj;

@property (nonatomic,strong)    NSString*   mStringDate;

@property (nonatomic,strong)    NSString*   mDateStr;

@property (nonatomic,strong)    NSString*   mWeek;

@property (nonatomic,strong)    NSArray*    mList;

@end

@interface SSMessage : NSObject

- (id)initWithObj:(NSDictionary *)obj;
///状态
@property (nonatomic,assign)    int         mStatus;
///id
@property (nonatomic,assign)    int         mId;
///发送时间
@property (nonatomic,strong)    NSString*   mSendTime;
///类型
@property (nonatomic,assign)    int         mType;
///标签
@property (nonatomic,strong)    NSString*   mTitle;
///内容
@property (nonatomic,strong)    NSString*   mContent;
///args参数
@property (nonatomic,strong)    NSString*   mArgs;
///是否已读？
@property (nonatomic,assign)    BOOL        mRead;

- (void)MsgRead;
+ (void)readAll:(void(^)(mBaseModel *mData))block;
@end