//  StickerView
//  VideoEdite
//
//  Created by WDeng on 16/11/25.
//  Copyright © 2016年 WDeng. All rights reserved.
//
#import <UIKit/UIKit.h> 

//  动画起始 持续 时间
typedef  struct  TimeRange{
    CGFloat beginPercent;
    CGFloat endPercent;
}TimeRange;


typedef void(^GenericCallback)(BOOL success, id result);

@class StickerView;

@protocol StickerViewDelegate <NSObject>

- (void)startTouchView:(StickerView *)view;
- (void)moveView:(StickerView *)view;
- (void)EndTouchView:(StickerView *)view;
- (void)currentActive:(StickerView *)view;

@end

@interface StickerView : UIView

@property (copy, nonatomic) GenericCallback deleteFinishBlock;
@property (nonatomic,weak) id <StickerViewDelegate>delegate;
@property (nonatomic,assign) BOOL isRote; // 默认 可旋转
@property (nonatomic,assign) TimeRange timeRange; ///<  动画起始 持续 时间
@property (nonatomic,assign) CGRect imageFrame;


+ (void)setActiveStickerView:(StickerView*)view;

- (id)initWithFilePath:(NSString *)path;

- (UIImageView*)imageView;
- (id)initWithImage:(UIImage *)image;
- (void)imageViewDefaultFrame;
- (void)setScale:(CGFloat)scale;
- (void)setScale:(CGFloat)scaleX andScaleY:(CGFloat)scaleY;

- (void)setVideoContentRect:(CGRect)videoContent;
- (CGRect)getVideoContentRect;

- (CGRect)getInnerFrame;
- (CGFloat)getRotateAngle;
- (NSString *)getFilePath;

- (void)isHiddenBorder:(BOOL)hidden;

@end
