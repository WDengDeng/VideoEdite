//
//  UIView+Frame.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/2.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setD_x:(CGFloat)d_x{
    
    CGRect frame = self.frame;
    frame.origin.x = d_x;
    self.frame = frame;
    
}

- (CGFloat)d_x{
    
    return self.frame.origin.x;
}

- (void)setD_y:(CGFloat)d_y{
    CGRect frame = self.frame;
    frame.origin.y = d_y;
    self.frame = frame;
}

- (CGFloat)d_y{
    
    return self.frame.origin.y;
}


- (CGFloat)d_top
{
    return self.frame.origin.y;
}
- (void)setD_top:(CGFloat)d_top
{
    CGRect frame = self.frame;
    frame.origin.y = d_top;
    self.frame = frame;
}


- (CGFloat)d_left
{
    return self.frame.origin.x;
}
- (void)setD_left:(CGFloat)d_left
{
    CGRect frame = self.frame;
    frame.origin.x = d_left;
    self.frame = frame;
}


- (CGFloat)d_bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setD_bottom:(CGFloat)d_bottom
{
    CGRect frame = self.frame;
    frame.origin.y = d_bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)d_right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setD_right:(CGFloat)d_right
{
    CGRect frame = self.frame;
    frame.origin.x = d_right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)d_centerX
{
    return self.center.x;
}
- (void)setD_centerX:(CGFloat)d_centerX
{
    CGPoint center = self.center;
    center.x = d_centerX;
    self.center = center;
}

- (CGFloat)d_centerY
{
    return self.center.y;
}
- (void)setD_centerY:(CGFloat)d_centerY
{
    CGPoint center = self.center;
    center.y = d_centerY;
    self.center = center;
}

- (CGFloat)d_width
{
    return self.frame.size.width;
}
- (void)setD_width:(CGFloat)d_width
{
    CGRect frame = self.frame;
    frame.size.width = d_width;
    self.frame = frame;
}

- (void)setD_origin:(CGPoint)d_origin {
    CGRect frame = self.frame;
    frame.origin = d_origin;
    self.frame = frame;
}

- (CGPoint)d_origin {
    return self.frame.origin;
}

- (CGFloat)d_height
{
    return self.frame.size.height;
}
- (void)setD_height:(CGFloat)d_height
{
    CGRect frame = self.frame;
    frame.size.height = d_height;
    self.frame = frame;
}

- (CGSize)d_size {
    return self.frame.size;
}
- (void)setD_size:(CGSize)d_size {
    CGRect frame = self.frame;
    frame.size = d_size;
    self.frame = frame;
}

@end
