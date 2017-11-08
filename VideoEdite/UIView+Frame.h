//
//  UIView+Frame.h
//  VideoEdite
//
//  Created by WDeng on 2017/11/2.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define D_SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define D_SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface UIView (Frame)

@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;

@property(nonatomic,assign) CGFloat top;
@property(nonatomic,assign) CGFloat left;
@property(nonatomic,assign) CGFloat bottom;
@property(nonatomic,assign) CGFloat right;
@property(nonatomic,assign) CGFloat centerX;
@property(nonatomic,assign) CGFloat centerY;
@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) CGFloat height;
@property(nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize size;
@end
