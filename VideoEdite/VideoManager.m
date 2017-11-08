//
//  VideoManager.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/7.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "VideoManager.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "StickerView.h"
#import "UIView+Frame.h"
#import "GifAnimationLayer.h"


@interface VideoManager ()
{
    CGFloat _exportProgress;
}
@property (nonatomic,strong) AVAsset *asset;
@property (nonatomic,strong) AVAssetExportSession *exportSession;
@property (nonatomic,strong) AVMutableComposition *mutableComposition;
@property (nonatomic,strong) AVMutableVideoComposition *mutableVideoComposition;

@property (nonatomic,copy) void(^progressBlock)(CGFloat progress) ;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation VideoManager



- (void)setupComposition {
    
    AVAssetTrack *assetVideoTrack = nil;
    AVAssetTrack *assetAudioTrack = nil;
    
    CMTime insertPoint = kCMTimeZero;
    NSError *error = nil;
    self.mutableComposition = [[AVMutableComposition alloc] init];
    if ([[self.asset tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        assetVideoTrack = [self.asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        AVMutableCompositionTrack * compositionVideoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [self.asset duration]) ofTrack:assetVideoTrack atTime:insertPoint error:&error];
    }
    if ([[self.asset tracksWithMediaType:AVMediaTypeAudio] count] != 0) {
        assetAudioTrack = [self.asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        AVMutableCompositionTrack *  compositionAudioTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [self.asset duration]) ofTrack:assetAudioTrack atTime:insertPoint error:&error];
    }
}

/**
 *  gif动画
 */
- (CALayer *)createAnimationLayer:(StickerView *)view videoSizeResult:(CGSize)videoSizeResult{
    
    CALayer *animatedLayer = nil;
    
    NSString *gifPath = view.getFilePath;
    CGFloat maxScale = 0;
    CGFloat videoW = 0;
    CGFloat videoH = 0;
    CGFloat videoX = 0;
    CGFloat videoY = 0;
    
    if ((videoSizeResult.width / videoSizeResult.height) > (D_SCREEN_WIDTH/D_SCREEN_HEIGHT)) { // 宽
        maxScale = videoSizeResult.width / D_SCREEN_WIDTH;
        
        videoW =  D_SCREEN_WIDTH;
        videoX = 0;
        
        videoH = videoSizeResult.height / maxScale;
        videoY = (D_SCREEN_HEIGHT  - videoH) / 2;
        
    } else { // 高
        maxScale = videoSizeResult.height / D_SCREEN_HEIGHT;
        
        videoH =  D_SCREEN_HEIGHT;
        videoY = 0;
        
        videoW =  videoSizeResult.width / maxScale;
        videoX = (D_SCREEN_WIDTH - videoW) / 2;
    }
    
#warning TODO
    
    CGFloat originX = view.frame.origin.x - videoX;
    CGFloat originY = view.frame.origin.y - (videoY+ videoH);
    CGFloat aniX = originX * maxScale;
    
    
    view.imageFrame = [view getInnerFrame];
    
    UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, videoSizeResult.width, videoSizeResult.height)];
    CGRect frames = [view.superview convertRect:view.frame toView:views];
    
    
    CGFloat aniY =  originY > 0 ? (-originY + view.imageFrame.size.height - 16) * maxScale : (-originY - view.imageFrame.size.height - 16) * maxScale;
    CGRect gifFrame = CGRectMake(aniX, aniY, view.imageFrame.size.width * maxScale, view.imageFrame.size.height * maxScale);
    if (gifFrame.size.width == 0  || gifFrame.size.height == 0 || (isnan( gifFrame.size.width) || isnan( gifFrame.size.width)) ) {
        return nil;
    }
    
    // 动画时间设置
    CGFloat second = CMTimeGetSeconds(self.asset.duration);
    CFTimeInterval beginTime = view.timeRange.beginPercent * second == 0 ? 0.1 : view.timeRange.beginPercent * second;
    animatedLayer = [GifAnimationLayer layerWithGifFilePath:gifPath withFrame:gifFrame withAniBeginTime:beginTime];
    CFTimeInterval duration = (view.timeRange.endPercent -view.timeRange.beginPercent) * second == 0 ? [(GifAnimationLayer *)animatedLayer getTotalDuration] : (view.timeRange.endPercent -view.timeRange.beginPercent) * second;
    
    
    NSMutableArray *imageArray = [NSMutableArray array];
    if (animatedLayer && [animatedLayer isKindOfClass:[GifAnimationLayer class]])
    {
        animatedLayer.opacity = 0.0f;
        
        CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc]init];
        
        [animation setKeyPath:@"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.autoreverses = NO;
        animation.repeatCount = INT16_MAX;
        animation.beginTime = beginTime;
        animation.repeatDuration = duration;
        NSDictionary *gifDic = [(GifAnimationLayer*)animatedLayer getValuesAndKeyTimes];
        NSMutableArray *keyTimes = [gifDic objectForKey:@"keyTimes"];
        for (int i = 0; i < [keyTimes count]; ++i)
        {
            CGImageRef image = [(GifAnimationLayer*)animatedLayer copyImageAtFrameIndex:i];
            if (image)
            {
                [imageArray addObject:(__bridge id)image];
            }
        }
        
        animation.values   = imageArray;
        animation.keyTimes = keyTimes;
        animation.duration = [(GifAnimationLayer*)animatedLayer getTotalDuration];
        animation.removedOnCompletion = NO;
        [animation setValue:@"stop" forKey:@"TAG"];
        
        [animatedLayer addAnimation:animation forKey:@"contents"];
        
        CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeOutAnimation.fromValue = @1.0f;
        fadeOutAnimation.toValue = @0.9f;
        fadeOutAnimation.additive = YES;
        fadeOutAnimation.removedOnCompletion = NO;
        fadeOutAnimation.beginTime = beginTime;
        fadeOutAnimation.duration = animation.beginTime + animation.duration + 2;
        fadeOutAnimation.fillMode = kCAFillModeBoth;
        fadeOutAnimation.repeatCount = INT16_MAX;
        [animatedLayer addAnimation:fadeOutAnimation forKey:@"opacityOut"];
        
    }
    
    return animatedLayer;
    
}

/**
 *  获取videosize
 */
- (CGSize)getVideoSize{
    
    AVMutableCompositionTrack *videoTrack = [self.mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                                 preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, self.asset.duration)
                        ofTrack:[[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0]
                         atTime:kCMTimeZero error:nil];
    
    // 3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, self.asset.duration);
    
    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    AVAssetTrack *videoAssetTrack = [[self.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(0, 0);
    CGAffineTransform t2 = CGAffineTransformRotate(t1, 0);
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
        t1 = CGAffineTransformMakeTranslation(self.asset.naturalSize.height, 0.0);
        t2 = CGAffineTransformRotate(t1, M_PI_2);
        
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
        t1 = CGAffineTransformMakeTranslation(0.0, self.asset.naturalSize.width);
        t2 = CGAffineTransformRotate(t1, -M_PI_2);
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
        t1 = CGAffineTransformMakeTranslation(self.asset.naturalSize.width, self.asset.naturalSize.height);
        t2 = CGAffineTransformRotate(t1, M_PI);
    }
    //            [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    
    [videolayerInstruction setTransform:t2 atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:self.asset.duration];
    
    
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    
    self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    
    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    self.mutableVideoComposition.renderSize = CGSizeMake(renderWidth, renderHeight);
    self.mutableVideoComposition.instructions = [NSArray arrayWithObject:mainInstruction];
    self.mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    
    
    return CGSizeMake(renderWidth, renderHeight);
}


- (void)exportGifVideoWithGifs:(NSArray *)gifs url:(NSURL *)url Progress:(void(^)(CGFloat progress))progressBlock failed:(void(^)(NSError *error))failedBlock finished:(void(^)(NSURL *videoUrl))saveBlock {
    self.asset = [AVAsset assetWithURL:url];
    [self setupComposition];
    
    self.progressBlock = progressBlock;
    CGSize videoSize = CGSizeZero;
    
    if ([[self.mutableComposition tracksWithMediaType:AVMediaTypeVideo] count] != 0) {
        if (!self.mutableVideoComposition) {
            self.mutableVideoComposition = [AVMutableVideoComposition videoComposition];
            videoSize = [self getVideoSize];
        }
    }
    
    
    // Animation
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    
    CGSize videoSizeResult = videoSize;
    parentLayer.frame = CGRectMake(0, 0, videoSize.width, videoSize.height);
    
    videoLayer.frame = parentLayer.frame;
    [parentLayer addSublayer:videoLayer];
    
    
    // Animation effects
    for (StickerView *view in gifs) {
        CALayer *animatedLayer =  [self createAnimationLayer:view videoSizeResult:videoSizeResult];
        if (animatedLayer) {
            
            [parentLayer addSublayer:animatedLayer];
        }
    }
    
    self.mutableVideoComposition.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    
    
    
    // Export
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSURL *outputUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/video.mp4", path]];
    [[NSFileManager defaultManager] removeItemAtURL:outputUrl error:nil];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:[self.mutableComposition copy] presetName:AVAssetExportPresetHighestQuality];
    exportSession.outputURL = outputUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    if (self.mutableVideoComposition)
    {
        exportSession.videoComposition = self.mutableVideoComposition;
    }
    
    self.exportSession = exportSession;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(exportProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
        switch (exportSession.status)
        {
            case AVAssetExportSessionStatusCompleted:
            {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSLog(@"Export Successful");
                    if (saveBlock) {
                        saveBlock(outputUrl);
                    }
                });
            }
                break;
            case AVAssetExportSessionStatusCancelled:{
                NSLog(@"取消导出");
                if (failedBlock) {
                    failedBlock(exportSession.error);
                }
            }
                break;
                
            default:{
                //                    dispatch_sync(dispatch_get_main_queue(), ^{
                if (failedBlock) {
                    failedBlock( exportSession.error);
                }
                //                    });
            }
                break;
                
        }
        
        [self.timer invalidate];
        self.timer = nil;

    }];
    
    
}


/**
 *  进度
 */
- (void)exportProgress {
    if (self.exportSession.progress > 1){
     return;
    }
    
    if (self.progressBlock){
        self.progressBlock(self.exportSession.progress);
    }
    
}

- (void)cancelExport {
    
    [self.timer invalidate];
    self.timer = nil;
}

@end















