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

@property (nonatomic) CGFloat d_x;
@property (nonatomic) CGFloat d_y;

@property(nonatomic) CGFloat d_top;
@property(nonatomic) CGFloat d_left;
@property(nonatomic) CGFloat d_bottom;
@property(nonatomic) CGFloat d_right;
@property(nonatomic) CGFloat d_centerX;
@property(nonatomic) CGFloat d_centerY;
@property(nonatomic) CGFloat d_width;
@property(nonatomic) CGFloat d_height;
@property(nonatomic) CGPoint d_origin;
@property (nonatomic,assign) CGSize d_size;
@end
