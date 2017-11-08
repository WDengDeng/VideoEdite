//
//  VideoFrameBar.m
//  ancda
//
//  Created by WDeng on 16/12/22.
//  Copyright © 2016年 WDeng. All rights reserved.
//

#import "VideoFrameBar.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+Frame.h"


@interface VideoFrameBar ()
{
    NSTimeInterval _totalTime;
    BOOL _isDrag;
}


@property (nonatomic,strong) NSURL *url;
@property(nonatomic, weak) UIImageView *handleView;
@property(nonatomic, weak) UIView *handleBgView;

@end

@implementation VideoFrameBar

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url {
    if (self = [super initWithFrame:frame]) {
        self.url = url;
        [self setBackgroundView];
        [self configureView];
    }
    return self;
}


- (void)setBackgroundView {
    
    UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:bgView];
    AVAsset *asset = [AVAsset assetWithURL:self.url];
    _totalTime = CMTimeGetSeconds(asset.duration);
        NSTimeInterval time = _totalTime / 10 ;
        CGFloat width = self.width / 10;
        for (int i = 0; i < 10; i++) {
            [self thumbnailImageAtTime:time * (i + 1) image:^(UIImage *image) {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
                 imageView.image = image;
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.layer.masksToBounds = YES;
                [bgView addSubview:imageView];
                
            }];
        }
}

- (void) thumbnailImageAtTime:(NSTimeInterval)time image:(void(^)(UIImage *image))imageBlock {
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:self.url options:nil] ;
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset] ;
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    
    CMTime pointTime = CMTimeMakeWithSeconds(_totalTime / time + 0.1, 1);
    
    NSError *thumbnailImageGenerationError = nil;
    CGImageRef  thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:pointTime actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (thumbnailImageGenerationError) {
        NSLog(@"thumbnailImageGenerationError %@", thumbnailImageGenerationError);
    }
    
    
    UIImage *thumbnailImage = [[UIImage alloc] initWithCGImage:thumbnailImageRef];
    CGImageRelease(thumbnailImageRef);
    NSData *data = UIImageJPEGRepresentation(thumbnailImage, 0.1);
    UIImage *image =  [UIImage imageWithData:data scale:20];
     
        
        dispatch_sync(dispatch_get_main_queue(), ^{
        if (imageBlock) {
            imageBlock(image);
        }
            
        });
    });
 
}


- (void)configureView {
    
    
    UIView *handleBgView = [[UIView alloc] initWithFrame:CGRectMake(4, 0, self.width - 8, self.height)];
    [self addSubview:handleBgView];
    self.handleBgView = handleBgView;
    
    UIImageView *handleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, self.height)];
    handleView.centerX = 0;
    handleView.image = [UIImage imageNamed:@"video_edite_handle"];
    handleView.contentMode = UIViewContentModeScaleAspectFit;
    [handleBgView addSubview:handleView];
    handleView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragHandle:)];
    [handleView addGestureRecognizer:pan];
    
    self.handleView = handleView;
}

- (void)dragHandle:(UIPanGestureRecognizer *)pan {
    
    UIView *handleView = pan.view;
    UIView *handleBgView = handleView.superview;
    
    CGPoint point = [pan translationInView:self];
    NSLog(@"NSStringFromCGPoint------------%@", NSStringFromCGPoint(point));
    handleView.centerX += point.x;
    if (handleView.centerX <= 0) {
        handleView.centerX = 0;
    }
    if (handleView.centerX >= handleBgView.width) {
        handleView.centerX = handleBgView.width;
    }
    if ([self.delegate respondsToSelector:@selector(dragHandleViewWithPercent:)]) {
        [self.delegate dragHandleViewWithPercent:handleView.centerX*1.0/handleBgView.width];
    }
    
    [pan setTranslation:CGPointZero inView:self];
    
   _isDrag = pan.state != UIGestureRecognizerStateEnded;
}

- (void)setPercent:(CGFloat)percent {
    if (!_isDrag) {
        self.handleView.centerX =  percent * self.handleBgView.width;
    }
    _percent = percent;
}

- (void)setHiddenHandle:(BOOL)hiddenHandle {
    self.handleView.hidden = hiddenHandle;
    _hiddenHandle = hiddenHandle;
}

@end







