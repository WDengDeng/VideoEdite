//
//  VideoManger.h
//  VideoEdite
//
//  Created by WDeng on 2017/11/7.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SaveBlock)(BOOL success, NSURL *videoUrl);
typedef void(^ProgressBlock) (NSProgress *progress);

@interface VideoManger : NSObject

@property (nonatomic, strong) NSArray *gifArray;
- (instancetype)initWithUrl:(NSURL *)url;

- (void)exportGifVideoWithGifs:(NSArray *)gifs Progress:(ProgressBlock)progressBlock saveBlock:(SaveBlock)saveBlock;


- (void)cancelExport;
@end
