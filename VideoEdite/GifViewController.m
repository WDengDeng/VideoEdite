//
//  GifViewController.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/2.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "GifViewController.h"
#import "UIView+Frame.h"
#import "VideoPlayerView.h"
#import "StickerView.h"
#import "VideoFrameBar.h"
#import "GifTimeView.h"
#import "VideoManager.h"
#import "GifAnimationLayer.h"


#define ITEM_W D_SCREEN_WIDTH /5

@interface GifViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, VideoPlayerViewDelegate, StickerViewDelegate, VideoFrameBarDelegate>
{
    
    BOOL _statusHidden;
}
@property(nonatomic, weak) UIView *navBar;
@property(nonatomic, weak) UIView *gifBar;
@property(nonatomic, weak) UIButton *playBtn;

@property(nonatomic, weak) VideoPlayerView *playerView;
@property(nonatomic, weak) VideoFrameBar *frameBar;
@property(nonatomic, weak) GifTimeView *timeView;
@property(nonatomic, weak) StickerView *sticker;


@property(nonatomic, strong) NSArray *gifAlbum;
@property(nonatomic, strong) NSMutableArray *stickerViews;


@end

@implementation GifViewController

static NSString *const CellID = @"gifcellid";

#pragma mark - Getter & Setter

- (NSMutableArray *)stickerViews {
    if (!_stickerViews) {
        _stickerViews = [NSMutableArray array];
    }
    return _stickerViews;
}

#pragma mark - Life
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configure];
}


#pragma mark - Views

- (void)configure {
    [self setupPlayerView];
    [self setupNavBar];
    [self setupFrameBar];
    [self setupGifBar];
    
}

- (void)setupPlayerView {
    VideoPlayerView *playerView = [[VideoPlayerView alloc] initWithFrame:self.view.bounds];
    playerView.videoURL = [[NSBundle mainBundle] URLForResource:@"video.mp4" withExtension:nil];
    playerView.delegate = self;
    playerView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapVideo:)];
    [playerView addGestureRecognizer:tap];
    [self.view addSubview:playerView];
    self.playerView = playerView;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    playBtn.bottom = D_SCREEN_HEIGHT - ITEM_W - 15;
    [playBtn setImage:[UIImage imageNamed:@"video_edite_play"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"video_edite_pause"] forState:UIControlStateSelected];
    [playBtn addTarget:self action:@selector(event_playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    self.playBtn = playBtn;
}

- (void)setupNavBar {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, D_SCREEN_WIDTH, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    self.navBar = navView;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    cancelBtn.centerY = navView.height/2 + 10;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(event_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    doneBtn.centerY = cancelBtn.centerY;
    doneBtn.titleLabel.textColor = [UIColor blackColor];
    doneBtn.right = D_SCREEN_WIDTH;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"导出" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(event_done:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:doneBtn];
}

- (void)setupFrameBar {
    
    VideoFrameBar *frameBar = [[VideoFrameBar alloc] initWithFrame:CGRectMake(0, self.navBar.bottom, D_SCREEN_WIDTH, 40) url:[[NSBundle mainBundle] URLForResource:@"video.mp4" withExtension:nil]];
    frameBar.delegate = self;
    [self.view addSubview:frameBar];
    self.frameBar = frameBar;
    
    GifTimeView *timeView = [[GifTimeView alloc] initWithFrame:CGRectMake(0, 0, 45, 40)];
    
    __weak typeof(self) weakSelf = self;
    
    timeView.blockValue = ^(CGFloat left, CGFloat right) {
        
        TimeRange range = {left, right};
        weakSelf.sticker.timeRange = range;
        weakSelf.frameBar.percent = left;
        weakSelf.playerView.percent = left;
    };
    timeView.hidden = YES;
    [frameBar addSubview:timeView];
    self.timeView = timeView;
}

- (void)setupGifBar {
    
    UIView *gifBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, D_SCREEN_WIDTH,ITEM_W)];
    gifBar.bottom = D_SCREEN_HEIGHT;
    gifBar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:gifBar];
    
    UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
    fl.itemSize = CGSizeMake(ITEM_W, ITEM_W );
    fl.minimumLineSpacing = 0.1;
    fl.minimumInteritemSpacing = 0.1;
    fl.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:gifBar.bounds collectionViewLayout:fl];
    collection.delegate = self;
    collection.dataSource = self;
    collection.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellID];
    [gifBar addSubview:collection];
    
    NSMutableArray *tempArr = [NSMutableArray array];
    for (int i = 0; i<23; i++) {
        [tempArr addObject:[NSString stringWithFormat:@"%d.gif", i]];
    }
    self.gifAlbum = [tempArr copy];
    
    self.gifBar = gifBar;
}

#pragma mark - UpdateViews

- (void)hiddenBar {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.playBtn.alpha = 0;
        self.frameBar.bottom = 0;
        self.navBar.bottom = 0;
        self.gifBar.top =  D_SCREEN_HEIGHT + self.gifBar.height;
    }];
}

- (void)showBar {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.playBtn.alpha = 1;
        self.navBar.top = 0;
        self.frameBar.top = self.navBar.height;
        self.gifBar.bottom = D_SCREEN_HEIGHT;
    }];
}

#pragma mark - Event

- (void)event_cancel:(UIButton *)btn {
    [self.playerView destroy];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)event_done:(UIButton *)btn {
    
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.layer.backgroundColor = [UIColor blackColor].CGColor;
    label.layer.opacity = 0.6;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [[VideoManager new] exportGifVideoWithGifs:self.stickerViews  url:self.playerView.videoURL Progress:^(CGFloat progress) {
        label.text = [NSString stringWithFormat:@"%.0f%%", progress*100];
    } failed:^(NSError *error) {
        [label removeFromSuperview];
        
    } finished:^(NSURL *videoUrl) {
        [label removeFromSuperview];
        NSLog(@"成功-------%@", videoUrl);
    }];
    
}

- (void)event_playVideo:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self playVideo];
    } else {
        [self pauseVideo];
    }
    
}


- (void)playVideo {
    
    self.frameBar.hiddenHandle = NO;
    self.timeView.hidden = YES;
    [self.playerView play];
}

- (void)pauseVideo {
    [self.playerView pause];
}
#pragma mark - collectiondeleagte
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gifAlbum.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.backgroundColor =[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    if (![cell viewWithTag:2003]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, ITEM_W - 10, ITEM_W -10)];
        imageView.layer.masksToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.center = CGPointMake(ITEM_W /2, ITEM_W/2);
        imageView.image = [UIImage imageNamed:self.gifAlbum[indexPath.row]];
        imageView.tag = 2003;
        [cell addSubview:imageView];
    } else {
        UIImageView *imageView = [cell viewWithTag:2003];
        imageView.image = [UIImage imageNamed:self.gifAlbum[indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self addGif:indexPath.row];
    
}




#pragma mark - VideoPlayerViewDelegate

- (void)changeSliderViewWithPercent:(CGFloat)percent {
    
}

- (void)videoPlayPercent:(CGFloat)percent {
 
    self.frameBar.percent = percent;
}

- (void)playFinish {
    
}


#pragma mark - StickerViewDelegate

- (void)startTouchView:(StickerView *)view {
 
    [self touchGif:view];
}

- (void)moveView:(StickerView *)view {
    
    [self dragGif];
}

- (void)EndTouchView:(StickerView *)view {
    
    [self showBar];
}

- (void)currentActive:(StickerView *)view {
    
}

#pragma mark - VideoFrameBarDelegate

- (void)dragHandleViewWithPercent:(CGFloat)percent {
    
    self.playerView.percent = percent;
    [self pauseVideo];
    self.playBtn.selected = NO;
}


#pragma mark - 操作
// 1.Gif
// 加入gif
- (void)addGif:(NSInteger)index {
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:self.gifAlbum[index] ofType:nil];
    
    StickerView *stickView = [[StickerView alloc] initWithFilePath:path];
    stickView.isRote = NO;
    CGFloat scale = MIN(0.3 * self.playerView.width / stickView.width, 0.5 * self.playerView.height / stickView.height);
    [stickView setScale:scale];
    stickView.center = CGPointMake(self.playerView.width/2 , self.playerView.height/2);
    [StickerView setActiveStickerView:stickView];
    [stickView setVideoContentRect:self.playerView.frame];
    
    stickView.delegate = self;
    stickView.deleteFinishBlock = ^(BOOL success, id result) {
        [self deleteGif:index];
        [self.stickerViews removeObject:result];
        self.timeView.hidden = !self.stickerViews.count;
    };
    
    TimeRange timeRange = {self.playerView.percent, 0.2};
    stickView.timeRange = timeRange;
    [self.timeView currentLeft:timeRange.beginPercent rightPercent:timeRange.endPercent];
    
    self.sticker= stickView;
    [self.playerView addSubview:stickView];
    [self.stickerViews addObject:stickView];
    
    
    self.timeView.hidden = NO;
}
- (void)touchGif:(StickerView *)view {
    if (self.playBtn.selected) {
        [self event_playVideo:self.playBtn];
    }
    
//    self.stickView = view;
    self.timeView.hidden = NO;
//    [self.stickView isHiddenBorder:NO];
//    self.progressBar.sliderView.handleView.hidden = YES;
//    [self.timeView currentLeft:view.timeRange.beginPercent rightValue:view.timeRange.endPercent];
    
    [self.timeView currentLeft:view.timeRange.beginPercent rightPercent:view.timeRange.endPercent];
    
}
// 拖动gif
- (void)dragGif {
    [self hiddenBar];
    
}

// 删除gif
- (void)deleteGif:(NSInteger)index {
    
    
    NSLog(@"xx");
}

// 2.FrameBar
// 拖动播放进度
// 设置动画范围

// 3.点击VideoView
- (void)tapVideo:(UITapGestureRecognizer *)tap {
    if (self.playBtn.selected) {
        [self event_playVideo:self.playBtn];
    }
    
}



@end











