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
    

    
}


- (IBAction)insetGIF:(id)sender {
    [self presentViewController:[GifViewController new] animated:YES completion:nil];
}


@end
