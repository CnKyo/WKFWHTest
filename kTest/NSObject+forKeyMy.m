//
//  NSObject+forKeyMy.m
//  kTest
//
//  Created by wangke on 16/1/6.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "NSObject+forKeyMy.h"

@implementation NSObject (myObj)
- (id)objectForMyKey:(id)mKey{

    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) {
        
        id selfObj = self;
        id otherObj  = [selfObj objectForKey:mKey];
        
        if ([otherObj isKindOfClass:[NSNull class]]) {
            return nil;
        }else{
            return otherObj;
        }
        
    }
    return nil;

}

@end
