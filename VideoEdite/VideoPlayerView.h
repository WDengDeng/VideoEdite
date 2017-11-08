//
//  VideoPlayerView.h
//  VideoEdite
//
//  Created by WDeng on 16/11/21.
//  Copyright © 2016年 WDeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoPlayerView;
@protocol VideoPlayerViewDelegate <NSObject>

- (void)changeSliderViewWithPercent:(CGFloat)percent;
- (void)videoPlayPercent:(CGFloat)percent ;
- (void)playFinish:(VideoPlayerView *)playerView;

@end

@interface VideoPlayerView : UIView
@property (nonatomic,assign) CGFloat percent;
@property (nonatomic,strong) NSURL *videoURL;
@property (nonatomic,weak) id <VideoPlayerViewDelegate>delegate;
@property (nonatomic,assign, readonly) CGFloat totalTime; 
@property(nonatomic, assign) CGSize videoSize;
- (instancetype)initWithFrame:(CGRect)frame ; 
- (void)play;
- (void)pause;
- (void)destroy;


@end
