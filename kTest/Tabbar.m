//
//  Tabbar.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "Tabbar.h"

@interface Tabbar()

@end

@implementation Tabbar


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tabBar.tintColor = COLOR(129, 180, 61);
    
}

-(void)setBadgeValue:(NSString*)val atTabIndex:(int)index

{
    
    UITabBarItem* tab = [[self.tabBar items] objectAtIndex:index];
    
    if ([val integerValue] <= 0) {
        
        tab.badgeValue = nil;
        
    }
    
    else
        
    {
        
        tab.badgeValue = val;
        
    }
    
}

-(NSString*)getBadgeValueAtIndex:(int)index

{
    
    UITabBarItem* tab = [[self.tabBar items] objectAtIndex:index];
    
    return tab.badgeValue;
    
}


@end
