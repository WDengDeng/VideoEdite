//
//  VideoFrameBar.h
//  ancda
//
//  Created by WDeng on 16/12/22.
//  Copyright © 2016年 WDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoFrameBarDelegate <NSObject>

- (void)dragHandleViewWithPercent:(CGFloat)percent;

@end
 

@interface VideoFrameBar : UIView

@property(nonatomic, weak) id delegate;
@property(nonatomic, assign) CGFloat percent;
@property(nonatomic, assign) BOOL hiddenHandle;

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url;

@end

