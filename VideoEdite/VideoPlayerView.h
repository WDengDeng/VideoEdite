//
//  VideoPlayerView.h
//  VideoEdite
//
//  Created by WDeng on 16/11/21.
//  Copyright © 2016年 WDeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol VideoPlayerViewDelegate <NSObject>

- (void)changeSliderViewWithPercent:(CGFloat)percent;
- (void)videoPlayPercent:(CGFloat)percent ;
- (void)playFinish;

@end

@interface VideoPlayerView : UIView
@property (nonatomic,assign) CGFloat percent;
@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,weak) id <VideoPlayerViewDelegate>delegate;
@property (nonatomic,assign, readonly) CGFloat totalTime; 

- (instancetype)initWithFrame:(CGRect)frame ; 
- (void)play;
- (void)pause;
- (void)destroy;


@end
