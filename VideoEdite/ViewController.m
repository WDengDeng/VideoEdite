//
//  ViewController.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/2.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "ViewController.h"
#import "GifViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoPlayerView.h"
#import "UIView+Frame.h"
#import "VideoManager.h"
@interface ViewController ()<VideoPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlayVideo) name:ExportVideoCompletion object:nil];
    [self setPlayVideo];
}

- (IBAction)closeBtn:(id)sender {
    [self playFinish:[self.view viewWithTag:10001]];
}


- (IBAction)insetGIF:(id)sender {
    [self presentViewController:[GifViewController new] animated:YES completion:nil];
}
- (IBAction)replayBtn:(id)sender {
    [self playFinish:[self.view viewWithTag:10001]];
    [self setPlayVideo];
}

- (void)setPlayVideo {
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *path = [NSString stringWithFormat:@"%@/video.mp4", document];
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:path]) {
        return;
    }
        self.closeBtn.hidden = NO;
        self.replayBtn.hidden = NO;
        VideoPlayerView *playerView = [[VideoPlayerView alloc] initWithFrame:CGRectZero];
        playerView.delegate = self;
        playerView.videoURL = [NSURL fileURLWithPath:path];
        playerView.size =CGSizeMake( playerView.videoSize.width * 0.5, playerView.videoSize.height * 0.5);
        playerView.center = self.view.center;
        playerView.layer.cornerRadius = 8;
        playerView.layer.masksToBounds = YES;
        playerView.tag = 10001;
        [self.view addSubview:playerView];
        [playerView play];
    
    
    
}
   

- (void)playFinish:(VideoPlayerView *)playerView {
    [playerView removeFromSuperview];
    [playerView destroy];
}

@end





