//
//  GifTimeView.h
//  VideoEdite
//
//  Created by WDeng on 2017/11/7.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GifTimeView : UIImageView

@property (nonatomic,copy) void(^blockValue)(CGFloat leftPercent, CGFloat rightPercent);
@property (nonatomic,assign, readonly) CGFloat leftPercent;
@property (nonatomic,assign, readonly) CGFloat rightPercent;

- (void)currentLeft:(CGFloat)leftPercent rightPercent:(CGFloat)rightPercent;

@end
