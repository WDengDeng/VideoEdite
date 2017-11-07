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


#define ITEM_W D_SCREEN_WIDTH /5

@interface GifViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, VideoPlayerViewDelegate, StickerViewDelegate, VideoFrameBarDelegate>
{
    
    BOOL _statusHidden;
}
@property(nonatomic, weak) UIView *navBar;
@property(nonatomic, weak) VideoFrameBar *frameBar;
@property(nonatomic, weak) UIView *gifBar;
@property(nonatomic, weak) VideoPlayerView *playerView;
@property(nonatomic, weak) UIButton *playBtn;

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
    [self.view addSubview:playerView];
    self.playerView = playerView;
    
    UIButton *playBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    playBtn.d_bottom = D_SCREEN_HEIGHT - ITEM_W - 15;
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
    cancelBtn.d_centerY = navView.d_height/2 + 10;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(event_cancel:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:cancelBtn];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
    doneBtn.d_centerY = cancelBtn.d_centerY;
    doneBtn.titleLabel.textColor = [UIColor blackColor];
    doneBtn.d_right = D_SCREEN_WIDTH;
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(event_done:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:doneBtn];
}

- (void)setupFrameBar {
    
    VideoFrameBar *frameBar = [[VideoFrameBar alloc] initWithFrame:CGRectMake(0, self.navBar.d_bottom, D_SCREEN_WIDTH, 40) url:[[NSBundle mainBundle] URLForResource:@"video.mp4" withExtension:nil]];
    frameBar.delegate = self;
    [self.view addSubview:frameBar];
    self.frameBar = frameBar;
}

- (void)setupGifBar {
    
    UIView *gifBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, D_SCREEN_WIDTH,ITEM_W)];
    gifBar.d_bottom = D_SCREEN_HEIGHT;
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
        self.frameBar.d_bottom = 0;
        self.navBar.d_bottom = 0;
        self.gifBar.d_top =  D_SCREEN_HEIGHT + self.gifBar.d_height;
    }];
}

- (void)showBar {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.playBtn.alpha = 1;
        self.navBar.d_top = 0;
        self.frameBar.d_top = self.navBar.d_height;
        self.gifBar.d_bottom = D_SCREEN_HEIGHT;
    }];
}

#pragma mark - Event

- (void)event_cancel:(UIButton *)btn {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)event_done:(UIButton *)btn {
    
}
- (void)event_playVideo:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.playerView play];
    } else {
        [self.playerView pause];
    }
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
    
}

- (void)moveView:(StickerView *)view {
    
    [self hiddenBar];
}

- (void)EndTouchView:(StickerView *)view {
    
    [self showBar];
}

- (void)currentActive:(StickerView *)view {
    
}

#pragma mark - VideoFrameBarDelegate

- (void)dragHandleViewWithPercent:(CGFloat)percent {
    
    self.playerView.percent = percent;
}


#pragma mark - 操作
// 1.Gif
// 加入gif
- (void)addGif:(NSInteger)index {
    
    NSString *path =  [[NSBundle mainBundle] pathForResource:self.gifAlbum[index] ofType:nil];
    StickerView *stickView = [[StickerView alloc] initWithFilePath:path];
    stickView.isRote = NO;
    CGFloat scale = MIN(0.3 * self.playerView.d_width / stickView.d_width, 0.5 * self.playerView.d_height / stickView.d_height);
    [stickView setScale:scale];
    stickView.center = CGPointMake(self.playerView.d_width/2 , self.playerView.d_height/2 );
    [StickerView setActiveStickerView:stickView];
    [stickView setVideoContentRect:self.playerView.frame];
    stickView.delegate = self;
    stickView.deleteFinishBlock = ^(BOOL success, id result) {
        [self deleteGif:index];
        [self.stickerViews removeObject:result];
    };
    [self.playerView addSubview:stickView];
    [self.stickerViews addObject:stickView];
}
// 拖动gif
- (void)dragGif {
    
}
// 删除gif
- (void)deleteGif:(NSInteger)index {
    
    NSLog(@"xx");
}


// 2.FrameBar
// 拖动播放进度
// 设置动画范围


@end











