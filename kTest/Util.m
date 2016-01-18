//
//  Util.m
//  WeiDianApp
//
//  Created by zzl on 14/12/5.
//  Copyright (c) 2014年 allran.mine. All rights reserved.
//

#import "Util.h"
#import <CommonCrypto/CommonDigest.h>


@implementation Util

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (BOOL)checkNum:(NSString *)numStr{
    
    if( [self isPureInt:numStr] || [self isPureFloat:numStr]){
        
        return YES;
        
    }
    return NO;
}


+(BOOL)checkSFZ:(NSString *)numStr
{
    if( numStr == nil || [numStr length] != 18 )
    {
        return NO;
    }
    
    char string_idnum[19];  // 身份证号码，最后一位留空，一会算出来最后一位
    
    char verifymap[] = "10X98765432";  // 加权乘积求和除以11的余数所对应的校验数
    
    int factor[] = {7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2, 1};  // 加权因子
    
    long sum = 0l;  //加权乘积求和
    
    int m = 0;  // 加权乘积求和的模数
    
    char * p = string_idnum;  // 当前位置
    
    memset(string_idnum, 0, sizeof(string_idnum));  // 清零
    
    const char* snum = [numStr cStringUsingEncoding:NSASCIIStringEncoding];
    
    strcpy(string_idnum, snum);  // 本体码，也就是前17位
    string_idnum[17] = '\0';
    
    while(*p)  // 在 '\0' 之前一直成立
        
    {
        
        sum += (*p - '0') * factor[p - string_idnum];  // 加权乘积求和
        
        p++;  // 当前位置增加1
        
    }
    
    m = sum % 11;  // 取模
    
    return verifymap[m] == snum[17];
}
+(NSDate*)dateWithInt:(double)second
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    return [date  dateByAddingTimeInterval: interval];
}
+(NSString*)getTimeStringPointSecond:(double)second//2015.06.18. 12:12:00
{
    return [Util getTimeStringPoint:[Util dateWithInt:second]];
}
+(NSString*)getTimeStringHourSecond:(double)second
{
    return [Util getTimeStringHour: [Util dateWithInt:second] ];
}

+(NSString *)dateForint:(double)time bfull:(BOOL)bfull
{
    NSDate *date = [Util dateWithInt:time];
    return [Util getTimeString:date bfull:bfull];
}
+(NSString*)getTimeString:(NSDate*)dat bfull:(BOOL)bfull
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: bfull ? @"yyyy-MM-dd HH:mm:ss" : @"yyyy-MM-dd HH:mm" ];
    NSString *strDate = [dateFormatter stringFromDate:dat];
    if( bfull ) return strDate;
    
    //  NSString *nodatetring = [dateFormatter stringFromDate:[NSDate date]];
    return strDate;
}
+ (NSString *)DateTimeInt:(int)time{
    
    NSDate *date = [Util dateWithInt:time];
    NSString *timeStr = [Util getTimeString:date bfull:NO];
    
    
    NSString *ss = timeStr;
    NSArray *a = [ss componentsSeparatedByString:@" "];
    NSString *s1 = [a objectAtIndex:0];
    
    NSArray *startTimeY = [s1 componentsSeparatedByString:@"-"];
    NSString *sm = [startTimeY objectAtIndex:1];
    NSString *sd = [startTimeY objectAtIndex:2];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSInteger unitFlags = NSWeekdayCalendarUnit;
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:[Util dateWithInt:time]];
    NSInteger wkd = [comps weekday];
    
    NSString* wdkstr = @"";
    switch (wkd) {
        case 1:
            wdkstr = @"日";
            break;
        case 2:
            wdkstr = @"一";
            break;
        case 3:
            wdkstr = @"二";
            break;
        case 4:
            wdkstr = @"三";
            break;
        case 5:
            wdkstr = @"四";
            break;
        case 6:
            wdkstr = @"五";
            break;
        case 7:
            wdkstr = @"六";
            break;
        default:
            break;
    }
    NSString *month = [NSString stringWithFormat:@"%@月%@日\n%@",sm,sd,wdkstr];
    return month;
    
    
}
+(NSString*)getTimeStringWithP:(double)time
{
    NSDate *date = [Util dateWithInt:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString*)getTimeStringHour:(NSDate*)dat   //date转字符串 2015-03-23 08:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString*)getTimeStringNoYear:(NSDate*)dat   //date转字符串 2015-03-23 08:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString*)getTimeStringS:(NSDate*)dat{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    return [dateFormatter stringFromDate:dat];
}
+(NSString*)getTimeStringSS:(NSDate*)dat   //date转字符串 20150415
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    return [dateFormatter stringFromDate:dat];
}


+(NSString*)getTimeStringPoint:(NSDate*)dat   //date转字符串 2015.03.23 08:00:00
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    return [dateFormatter stringFromDate:dat];
}

+(NSString *) FormartTime:(NSDate*) compareDate
{
    
    if( compareDate == nil ) return @"";
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = timeInterval;
    NSString *result;
    
    if (timeInterval < 60) {
        if( temp == 0 )
            result = @"刚刚";
        else
            result = [NSString stringWithFormat:@"%d秒前",(int)temp];
    }
    else if(( timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%d分钟前",(int)temp/60];
    }
    
    else if(( temp/86400) <30){
        
        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"dd"];
        NSString *str = [date stringFromDate:[NSDate date]];
        int nowday = [str intValue];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        int day = [strDate intValue];
        if (nowday-day==0) {
            [dateFormatter setDateFormat:@"今天 HH:mm"];
            result =    [dateFormatter stringFromDate:compareDate];
        }
        else if(nowday-day==1)
        {
            
            [dateFormatter setDateFormat:@"昨天 HH:mm"];
            result =  [dateFormatter stringFromDate:compareDate];
            
            
        }
        
        
        else if( temp < 8 )
        {
            if (temp==1) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"昨天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            else if(temp == 2)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"前天HH:mm"];
                NSString *strDate = [dateFormatter stringFromDate:compareDate];
                result = strDate;
            }
            
        }
        else
        {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:compareDate];
            result = strDate;
            
        }
    }
    else
    {//超过一个月的就直接显示时间了
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *strDate = [dateFormatter stringFromDate:compareDate];
        result = strDate;
    }
    
    /*
     else if((temp = (temp/(3600*24))/30) <12){
     result = [NSString stringWithFormat:@"%d个月前",(int)temp];
     }
     else{
     temp = temp/12;
     result = [NSString stringWithFormat:@"%d年前",(int)temp];
     }
     */
    
    return  result;
}


+(UIImage*)scaleImg:(UIImage*)org maxsizeW:(CGFloat)maxW //缩放图片,,最大多少
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    
    if( org.size.width > maxW )
    {
        w = maxW;
        h = (w / org.size.width) * org.size.height;
    }
    else
    {
        w = org.size.width;
        h = org.size.height;
        return org;
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}

//缩放图片
+(UIImage*)scaleImg:(UIImage*)org maxsize:(CGFloat)maxsize
{
    
    UIImage* retimg = nil;
    
    CGFloat h;
    CGFloat w;
    if( org.size.width > org.size.height )
    {
        if( org.size.width > maxsize )
        {
            w = maxsize;
            h = (w / org.size.width) * org.size.height;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    else
    {
        if( org.size.height > maxsize )
        {
            h = maxsize;
            w = (h / org.size.height) * org.size.width;
        }
        else
        {
            w = org.size.width;
            h = org.size.height;
            return org;
        }
    }
    
    UIGraphicsBeginImageContext( CGSizeMake(w, h) );
    
    [org drawInRect:CGRectMake(0, 0, w, h)];
    retimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return retimg;
}


//相对布局 base基准控件 dif间隔距离 tag要移动的控件 tagatdic tag在base的哪个位置
+(void)relPosUI:(UIView*)base dif:(CGFloat)dif tag:(UIView*)tag tagatdic:(RelDic)dic
{
    CGRect bf = base.frame;
    CGRect f = tag.frame;
    if( base != tag.superview )
    {
        switch ( dic ) {
            case E_dic_l:
                f.origin.x = bf.origin.x - dif - f.size.width;
                break;
            case E_dic_r:
                f.origin.x = bf.origin.x + bf.size.width + dif;
                break;
            case E_dic_t:
                f.origin.y = bf.origin.y - f.size.height  - dif;
                break;
            case E_dic_b:
                f.origin.y = bf.origin.y + bf.size.height + dif;
                break;
            default:
                break;
        }
        
        tag.frame = f;
    }
    else
    {//如果是基于父view
        switch ( dic ) {
            case E_dic_l:
                f.origin.x = dif;
                break;
            case E_dic_r:
                f.origin.x = bf.size.width - f.size.width - dif;
                break;
            case E_dic_t:
                f.origin.y = bf.size.height - f.size.height - dif;
                break;
            case E_dic_b:
                f.origin.y = dif;
                break;
            default:
                break;
        }
        
        tag.frame = f;
    }
    
}
+(void)autoExtendH:(UIView*)tagview dif:(CGFloat)dif
{//寻找所有子view,最底部的那个
    
    CGFloat offset = 0.0f;
    BOOL b = NO;
    for( UIView* one in tagview.subviews )
    {
        if( one.hidden ) continue;
        b = YES;
        CGFloat t   = one.frame.origin.y + one.frame.size.height;
        offset = t > offset ? t :offset;
    }
    
    if( !b ) return;
    
    CGRect f = tagview.frame;
    f.size.height = offset + dif;
    tagview.frame = f;
}
+(void)autoExtendH:(UIView*)tagview blow:(UIView*)subview dif:(CGFloat)dif
{
    CGRect f = tagview.frame;
    
    f.size.height = subview.frame.origin.y + subview.frame.size.height + dif;
    
    tagview.frame = f;
}



+(BOOL)checkPasswdPre:(NSString *)passwd
{
    if (passwd.length<6||passwd.length>20) {
        return NO;
    }
    return YES;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * newMOBILE = @"^1(7[7])\\d{8}$";
    
    
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[23478])\\d)\\d{7}$";
    
    
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|4[57]|5[256]|76|8[156])\\d{8}$";
    
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|7[0678]|8[019])[0-9]|349)\\d{7}$";
    
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestgh = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestbs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", newMOBILE];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestgh evaluateWithObject:mobileNum] == YES)
        || ([regextestbs evaluateWithObject:mobileNum] == YES)
        
        )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)md5_16:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0+4], result[1+4], result[2+4], result[3+4],
            result[4+4], result[5+4], result[6+4], result[7+4]
            ];
}

+(void)md5_16_b:(NSString*)str outbuffer:(char*)outbuffer
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    memcpy(outbuffer, &result[4], 8);
}


+(NSDictionary*)delNUll:(NSDictionary*)dic
{
    NSArray* allk = dic.allKeys;
    NSMutableDictionary* tmp = NSMutableDictionary.new;
    for ( NSString* onek in allk ) {
        id v = [dic objectForKey:onek];
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [Util delNullInArr:v] ;
            [tmp setObject:ta forKey:onek];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [Util delNUll:v];
            [tmp setObject:td forKey:onek];
            continue;
        }
        [tmp setObject:v forKey:onek];
    }
    return tmp;
}
+(NSArray*)delNullInArr:(NSArray*)arr
{
    NSMutableArray* tmp = NSMutableArray.new;
    for ( id v in arr ) {
        if( [v isKindOfClass:[NSNull class] ] )
        {//如果是nsnull 不要
            continue;
        }
        if( [v isKindOfClass:[NSArray class]] || [v isKindOfClass: [NSMutableArray class]] )
        {
            NSArray* ta = [Util delNullInArr:v] ;
            [tmp addObject:ta];
            continue;
        }
        if( [v isKindOfClass:[NSDictionary class]] || [v isKindOfClass:[NSMutableDictionary class]] )
        {
            NSDictionary* td = [Util delNUll:v];
            [tmp addObject:td];
            continue;
        }
        [tmp addObject:v];
    }
    return tmp;
}

+(UIColor*)stringToColor:(NSString*)str
{
    if( str.length != 7 ) return nil;
    //#54fd13
    NSString* r = [str substringWithRange:NSMakeRange(1, 2)];
    unsigned long rv = strtoul( [r UTF8String] , NULL, 16);
    
    NSString* g = [str substringWithRange:NSMakeRange(3, 2)];
    unsigned long gv = strtoul( [g UTF8String] , NULL, 16);
    
    NSString* b = [str substringWithRange:NSMakeRange(5, 2)];
    unsigned long bv = strtoul( [b UTF8String] , NULL, 16);
    
    return ColorRGB(rv,gv,bv);
}

+(NSString*)getDistStr:(int)dist
{
    if( dist < 1000 )
        return [NSString stringWithFormat:@"%dm",dist];
    else if( dist < 1000*100 )
        return [NSString stringWithFormat:@"%dkm",dist/1000];
    else
        return @">100km";
}

//MARK: sign
+ (NSString *)genWxSign:(NSDictionary *)signParams parentkey:(NSString*)parentkey
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    [sign appendFormat:@"key=%@",parentkey];
    
    return  [[Util md5:sign] uppercaseString];
}

//MARK: sign
+ (NSString *)genWXClientSign:(NSDictionary *)signParams
{
    // 排序
    NSArray *keys = [signParams allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    // 生成
    NSMutableString *sign = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [sign appendString:key];
        [sign appendString:@"="];
        [sign appendString:[signParams objectForKey:key]];
        [sign appendString:@"&"];
    }
    NSString *signString = [[sign copy] substringWithRange:NSMakeRange(0, sign.length - 1)];
    
    return [Util sha1:signString];;
}

+ (NSString *)sha1:(NSString *)input
{
    const char *ptr = [input UTF8String];
    
    int i =0;
    int len = strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}


//requrl http://api.fun.com/getxxxx
//
+(NSString*)makeURL:(NSString*)requrl param:(NSDictionary*)param
{
    if( param.count == 0 ) return requrl;
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"%@=%@&",onek,param[onek]];
    }
    return [NSString stringWithFormat:@"%@?%@",requrl,[reqstr substringToIndex:reqstr.length-2]];
}

//生成XML
+(NSString*)makeXML:(NSDictionary*)param
{
    if( param.count == 0 ) return @"";
    
    NSArray* allk = param.allKeys;
    NSMutableString* reqstr = NSMutableString.new;
    [reqstr appendString:@"<xml>\n"];
    for ( NSString* onek in allk ) {
        [reqstr appendFormat:@"<%@>%@</%@>\n",onek,param[onek],onek];
    }
    [reqstr appendString:@"</xml>"];
    return reqstr;
}

+(NSString*)getAppVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}



/*
 + (NSString *)getIPAddress:(BOOL)preferIPv4
 {
 NSArray *searchArray = preferIPv4 ?
 @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
 @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
 
 NSDictionary *addresses = [self getIPAddresses];
 //NSLog(@"addresses: %@", addresses);
 
 __block NSString *address;
 [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
 {
 address = addresses[key];
 if(address) *stop = YES;
 } ];
 return address ? address : @"0.0.0.0";
 }
 
 + (NSDictionary *)getIPAddresses
 {
 NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
 
 // retrieve the current interfaces - returns 0 on success
 struct ifaddrs *interfaces;
 if(!getifaddrs(&interfaces)) {
 // Loop through linked list of interfaces
 struct ifaddrs *interface;
 for(interface=interfaces; interface; interface=interface->ifa_next) {
 if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
 continue; // deeply nested code harder to read
 }
 const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
 if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
 NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
 char addrBuf[INET6_ADDRSTRLEN];
 if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
 NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
 addresses[key] = [NSString stringWithUTF8String:addrBuf];
 }
 }
 }
 // Free memory
 freeifaddrs(interfaces);
 }
 
 // The dictionary keys have the form "interface" "/" "ipv4 or ipv6"
 return [addresses count] ? addresses : nil;
 }
 
 */

+(int)gettopestV:(int)v
{
    int r = v;
    while ( r > 10 )
    {
        r  = r/10;
    }
    return r;
}


+(NSString*)URLEnCode:(NSString*)str
{
    NSString *resultStr = str;
    
    CFStringRef originalString = (__bridge CFStringRef) str;
    CFStringRef leaveUnescaped = CFSTR(" ");
    CFStringRef forceEscaped = CFSTR("!*'();:@&=+$,/?%#[]");
    
    CFStringRef escapedStr;
    escapedStr = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                         originalString,
                                                         leaveUnescaped,
                                                         forceEscaped,
                                                         kCFStringEncodingUTF8);
    
    if( escapedStr )
    {
        NSMutableString *mutableStr = [NSMutableString stringWithString:(__bridge NSString *)escapedStr];
        CFRelease(escapedStr);
        
        // replace spaces with plusses
        [mutableStr replaceOccurrencesOfString:@" "
                                    withString:@"%20"
                                       options:0
                                         range:NSMakeRange(0, [mutableStr length])];
        resultStr = mutableStr;
    }
    return resultStr;
}

+(NSString*)URLDeCode:(NSString*)str
{
    return [[str      stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//20150416 => 4月16日
+(NSString*)convdatestr:(NSString*)str
{
    if( str.length == 8 )
    {
        NSString* m = [str substringWithRange:NSMakeRange(4, 2)];
        NSString* d = [str substringWithRange:NSMakeRange(6, 2)];
        
        return [NSString stringWithFormat:@"%@月%@日",m,d];
    }
    return str;
}


+ (NSString *)startTimeStr:(NSString *)startTime andEndTime:(NSString *)endTime{
    NSString *ss = startTime;
    NSArray *a = [ss componentsSeparatedByString:@" "];
    NSString *s1 = [a objectAtIndex:0];
    NSString *s2 = [a objectAtIndex:1];
    
    NSArray *startTimeY = [s1 componentsSeparatedByString:@"-"];
    NSString *sm = [startTimeY objectAtIndex:1];
    NSString *sd = [startTimeY objectAtIndex:2];
    
    NSArray *startTimeH = [s2 componentsSeparatedByString:@":"];
    NSString *sh = [startTimeH objectAtIndex:0];
    NSString *sc = [startTimeH objectAtIndex:1];
    
    NSString *LsTime = [NSString stringWithFormat:@"%@/%@ %@:%@",sm,sd,sh,sc];
    
    
    
    NSString *sss = endTime;
    NSArray *a1 = [sss componentsSeparatedByString:@" "];
    NSString *s3 = [a1 objectAtIndex:0];
    NSString *s4 = [a1 objectAtIndex:1];
    
    NSArray *endTimeY = [s3 componentsSeparatedByString:@"-"];
    NSString *em = [endTimeY objectAtIndex:1];
    NSString *ed = [endTimeY objectAtIndex:2];
    
    NSArray *endTimeH = [s4 componentsSeparatedByString:@":"];
    NSString *eh = [endTimeH objectAtIndex:0];
    NSString *ec = [endTimeH objectAtIndex:1];
    
    NSString *LeTime = [NSString stringWithFormat:@"%@/%@ %@:%@",em,ed,eh,ec];
    
    NSString *TT = [NSString stringWithFormat:@"%@-%@",LsTime,LeTime];
    return TT;
}
+ (NSString *)startTimeStr:(NSString *)startSS{
    
    if (startSS.length == 0) {
        return startSS;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date2 =  [dateFormatter dateFromString:startSS];
    
    
    NSString* dateNow;
    dateNow = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *date1 = [dateFormatter dateFromString:dateNow];
    
    if ([date1 isEqualToDate:date2]) {
        return @"今天";
    }
    else if ([[date1 dateByAddingTimeInterval:86400] isEqualToDate:date2]) {
        return @"明天";
    }
    else if ([[date1 dateByAddingTimeInterval:86400*2]isEqualToDate:date2])
    {
        return @"后天";
    }else{
        return [[startSS substringFromIndex:6] stringByAppendingString:@"号"];
    }
    
}

+ (CGFloat)labelText:(NSString *)s fontSize:(NSInteger)fsize labelWidth:(CGFloat)width{
    UIFont *font = [UIFont systemFontOfSize:fsize];
    CGSize size  = CGSizeMake(width,2000);
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGSize labelsize    = CGSizeZero;
    if (systemVersion >= 7.0){
        NSDictionary *tdic =  [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        labelsize = [s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }else {
        labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return labelsize.height;
}
+ (CGFloat)labelText:(NSString *)s fontSize:(NSInteger)fsize labelHeight:(CGFloat)height{
    UIFont *font = [UIFont systemFontOfSize:fsize];
    CGSize size  = CGSizeMake(2000,height);
    
    float systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    CGSize labelsize    = CGSizeZero;
    if (systemVersion >= 7.0){
        NSDictionary *tdic =  [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        labelsize = [s boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    }else {
        labelsize = [s sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return labelsize.width;
}

+ (NSString *)mFirstStr:(NSString *)mFirstStr andSecondStr:(NSString *)secondStr{
    
    NSString *ss = mFirstStr;
    NSArray *a = [ss componentsSeparatedByString:@" "];
    NSString *s1 = [a objectAtIndex:0];
    NSString *s2 = [a objectAtIndex:1];
    
    NSArray *startTimeY = [s1 componentsSeparatedByString:@"-"];
    NSString *sm = [startTimeY objectAtIndex:1];
    NSString *sd = [startTimeY objectAtIndex:2];
    
    NSString *month = [NSString stringWithFormat:@"%@月%@日",sm,sd];
    
    NSString *ss8 = secondStr;
    NSArray *ssss1 = [ss8 componentsSeparatedByString:@" "];
    NSString *s20 = [ssss1 objectAtIndex:1];
    
    NSString *tt = [NSString stringWithFormat:@"%@ %@-%@",month,s2,s20];
    
    return tt;
    
}
+ (int)mTimeToInt:(NSDate *)dateStr{
    
    int finalitime = [[NSString stringWithFormat:@"%f",[dateStr timeIntervalSince1970]]intValue]-3600*8;
    return finalitime;
}
+ (NSString *)mDuration:(int)Duration{
    
    int hour =  Duration/3600;
    int munite = Duration/60%60;
    
    int mm = Duration/60;
    
    NSString *str = nil;
    if (mm >= 60) {
        str = [NSString stringWithFormat:@"%d小时%d分钟",hour,munite];
    }
    if (mm<=60) {
        str = [NSString stringWithFormat:@"%d分钟",munite];
    }
    
    return str;
}
+(NSMutableAttributedString *)labelWithUnderline:(NSString *)mString{
    NSMutableAttributedString *phoneStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", mString]];
    NSRange phoneRange = {0,[phoneStr length]};
    [phoneStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:phoneRange];
    return phoneStr;
}


+ (NSString *)mStartTimeArr:(NSArray *)Sarr andmEndTimeArr:(NSArray *)Earr{
    
    NSMutableArray  *tempArr = [NSMutableArray new];
    
    for (int i = 0;i<Sarr.count;i++) {
        NSString *string = [NSString stringWithFormat:@"%@-%@",Sarr[i],Earr[i]];
        [tempArr addObject:string];
        
    }
    NSString *ArrStr = [NSString stringWithFormat:@"%@",tempArr];
    
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()"];
    ArrStr = [[ArrStr componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    
    lll(@"/-------------%@---------------/",ArrStr);
    return ArrStr;
}
+ (UIImage *)imageFromView: (UIView *) theView
{
    
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
///时间date转时间戳
+ (int)DateToInt:(NSString *)date{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"HH:mm"];
    NSDate* inputDate = [inputFormatter dateFromString:date];
    NSLog(@"date = %@", inputDate);
    
    int finalitime = [[NSString stringWithFormat:@"%f",[inputDate timeIntervalSince1970]]intValue];
    return finalitime;
    
}

///2个时间比较大小
+ (NSDate *)CompareTime:(NSString *)mTimeStr{
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"HH:mm"];
    NSDate* date1 = [formater dateFromString:mTimeStr];
    NSLog(@"第一个时间：%@", date1);
    return date1;
    
}
+ (NSString *)getAPPName{
    
    NSString *AppName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
    
    return AppName;
    
}
+ (NSString *)getAppSchemes{
    NSString* File = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:File];
    
    NSString *str = nil;
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSDictionary *dic in [dict objectForKey:@"CFBundleURLTypes"]) {
        str  = [dic objectForKey:@"CFBundleURLSchemes"];
        [tempArr addObject:str];
    }
    return tempArr[0];
}
@end







