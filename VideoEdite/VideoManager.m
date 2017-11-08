//
//  VideoManger.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/7.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "VideoManger.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VideoManager ()
{
    AVAssetImageGenerator *_imageGenerator;
    CGFloat _exportProgress;
    NSInteger _failCount ;
    
}
@property (nonatomic,strong) AVAsset *asset;
@property (nonatomic,strong) AVMutableAudioMix *mutableAudioMix;
@property (nonatomic,strong) AVAssetExportSession *exportSession;
@property (nonatomic,strong) AVMutableComposition *mutableComposition;
@property (nonatomic,strong) AVMutableVideoComposition *mutableVideoComposition;
@property (nonatomic,strong) CALayer *aniLayer;


@implementation VideoManger
- (void)configure {
    
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
@end
