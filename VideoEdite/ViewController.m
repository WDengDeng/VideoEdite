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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)videoComposition:(id)sender {
    
}
- (IBAction)videoTailor:(id)sender {
    
    //初始化语音播报
    AVSpeechSynthesizer * av = [[AVSpeechSynthesizer alloc]init];
    //设置播报的内容
    AVSpeechUtterance * utterance = [[AVSpeechUtterance alloc]initWithString:@"视频裁剪"];
    AVSpeechSynthesisVoice * voiceType = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-cn"];
    utterance.voice = voiceType;
    //设置播报语速
    utterance.rate = 0.4;
    [av speakUtterance:utterance];
    
}


- (IBAction)insetGIF:(id)sender {
    [self presentViewController:[GifViewController new] animated:YES completion:nil];
    
}


@end
