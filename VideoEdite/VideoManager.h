//
//  VideoManager.h
//  VideoEdite
//
//  Created by WDeng on 2017/11/7.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VideoManager : NSObject
 

- (void)exportGifVideoWithGifs:(NSArray *)gifs url:(NSURL *)url Progress:(void(^)(CGFloat progress))progressBlock failed:(void(^)(NSError *error))failedBlock finished:(void(^)(NSURL *videoUrl))saveBlock;


- (void)cancelExport;
@end
