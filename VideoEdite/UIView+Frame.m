//
//  UIView+Frame.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/2.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setX:(CGFloat)x{
    
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
    
}

- (CGFloat)x{
    
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y{
    
    return self.frame.origin.y;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}
- (void)setTop:(CGFloat)aTop
{
    CGRect frame = self.frame;
    frame.origin.y = aTop;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}
- (void)setLeft:(CGFloat)aLeft
{
    CGRect frame = self.frame;
    frame.origin.x = aLeft;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setBottom:(CGFloat)aBottom
{
    CGRect frame = self.frame;
    frame.origin.y = aBottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setRight:(CGFloat)aRight
{
    CGRect frame = self.frame;
    frame.origin.x = aRight - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}
- (void)setCenterX:(CGFloat)aCenterX
{
    CGPoint center = self.center;
    center.x = aCenterX;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}
- (void)setCenterY:(CGFloat)aCenterY
{
    CGPoint center = self.center;
    center.y = aCenterY;
    self.center = center;
}

//宽度
- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)aWidth
{
    CGRect frame = self.frame;
    frame.size.width = aWidth;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (CGFloat)height
{
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)aHeight
{
    CGRect frame = self.frame;
    frame.size.height = aHeight;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
@end
