//
//  VideoPlayerView.m
//  VideoEdite
//
//  Created by WDeng on 16/11/21.
//  Copyright © 2016年 WDeng. All rights reserved.
//

#import "VideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

#define PLAYING_STATE @"status" //播放状态

@interface VideoPlayerView ()
{
    BOOL _isEnd;
}
@property (nonatomic,strong) AVPlayerLayer *playLayer;
@property (nonatomic,strong) AVPlayer *player;
@property (nonatomic,strong) AVPlayerItem  *item;
@property (nonatomic,strong) AVAsset *asset;

@property (nonatomic,assign) id timeObser;
@end

@implementation VideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
 

- (void)play {
    if (_isEnd) {
        [self.player seekToTime:kCMTimeZero];
    }
    _isEnd = NO;
    [self.player play];
}

- (void)setVideoURL:(NSURL *)videoURL {
    AVPlayerItem *item;
    if (!self.player.currentItem) {
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        item = [AVPlayerItem playerItemWithAsset:asset];
        self.player = [AVPlayer playerWithPlayerItem:item];
        self.playLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playLayer.frame = self.bounds;
        self.playLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        [self.layer addSublayer:self.playLayer];
        self.asset = asset;
    } else {
        [self.player replaceCurrentItemWithPlayerItem:[[AVPlayerItem alloc] initWithURL:videoURL]];
    }
    
    [self.player addObserver:self forKeyPath:PLAYING_STATE options:NSKeyValueObservingOptionNew context:nil];
    
    
    _totalTime = CMTimeGetSeconds(self.asset.duration);
    __weak typeof(self) weakSelf = self;
    _timeObser =  [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30) queue:dispatch_get_global_queue(0, 0) usingBlock:^(CMTime time) {
    
        dispatch_sync(dispatch_get_main_queue(), ^{
            float currentTimeValue = CMTimeGetSeconds(time);
            CGFloat progress = currentTimeValue /_totalTime;
            NSLog(@"%f,   %f,  %fm", currentTimeValue, weakSelf.totalTime, progress);
            if ([weakSelf.delegate respondsToSelector:@selector(videoPlayPercent:)]) {
                [weakSelf.delegate videoPlayPercent:progress];
            }
        });
   
        
    }];
    _videoURL = videoURL;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (object == self.player && [keyPath isEqualToString:PLAYING_STATE]) {
        if (self.player.status == AVPlayerStatusReadyToPlay) {
            if ([self.delegate respondsToSelector:@selector(changeSliderViewWithPercent:)]) {
                [self.delegate changeSliderViewWithPercent:0.2];
                [self.delegate changeSliderViewWithPercent:0.0];
            }
        }
    }
}

- (void)pause {
    [self.player pause];
}

- (void)destroy{
    [self.player pause];
    [self.player removeObserver:self forKeyPath:PLAYING_STATE];
    [self removeFromSuperview];
    [self.player removeTimeObserver:_timeObser];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playEnd {
    _isEnd = YES;
    [self.player pause];
    [self.player seekToTime:kCMTimeZero];
    if ([self.delegate respondsToSelector:@selector(playFinish)]) {
        [self.delegate playFinish];
    }
}

- (void)setPercent:(CGFloat)percent {
    int begin = _totalTime * percent *1.0;
    [self.player seekToTime:CMTimeMake(begin, 1)];
    _isEnd = NO;
    _percent = percent;
}




@end





