//
//  GifTimeView.m
//  VideoEdite
//
//  Created by WDeng on 2017/11/7.
//  Copyright © 2017年 WDeng. All rights reserved.
//

#import "GifTimeView.h"
#import "UIView+Frame.h"

@interface GifTimeView ()

@property (nonatomic, weak) UIView *rightView;
@property (nonatomic, weak) UIView *leftView;

@end

@implementation GifTimeView

static NSInteger Handle_W = 15;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"video_edite_range"];
        [self configure];
    }
    return self;
}

- (void)configure {
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(self.width - Handle_W, 0, Handle_W, self.height)];
    rightView.tag = 1000;
    [self addSubview:rightView];
    UIPanGestureRecognizer *panR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
    [rightView addGestureRecognizer:panR];
    self.rightView = rightView;
    
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.width - rightView.width, self.height)];
    [self addSubview:leftView];
    leftView.tag = 1001;
    UIPanGestureRecognizer *panL = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
    [leftView addGestureRecognizer:panL];
    self.leftView = leftView;
    
}

- (void)moveView:(UIPanGestureRecognizer *)pan {
    CGPoint point = [pan translationInView:self];
    
    CGRect frame = self.frame;
    if (pan.view.tag == 1000) { // right
        CGFloat value = point.x + frame.size.width;
        if (value <= Handle_W *2) {
            value = Handle_W *2;
        }
        frame.size.width = value;
    } else if ( pan.view.tag == 1001) { // left
        
        CGFloat value = point.x + frame.origin.x;
        
        if (D_SCREEN_WIDTH - value  <= Handle_W *2) {
            value = D_SCREEN_WIDTH - Handle_W *2;
        }
        frame.origin.x =value;
    }
    
    if ((frame.origin.x + frame.size.width ) > D_SCREEN_WIDTH) {
        frame.size.width= D_SCREEN_WIDTH - frame.origin.x;
        
    }
    if (frame.origin.x < 0) {
       frame.origin.x = 0;
    }
    
    self.frame = frame;
    [self updateLayout];
    [pan setTranslation:CGPointZero inView:self];
}

- (void)updateLayout {
    self.leftView.frame = CGRectMake(0, 0, self.width - Handle_W , self.height);
    self.rightView.frame = CGRectMake(self.width - Handle_W, 0, Handle_W, self.height);
    _leftPercent = self.x / D_SCREEN_WIDTH;
    _rightPercent =  self.width  / D_SCREEN_WIDTH;
    
    if (self.blockValue) {
        self.blockValue(_leftPercent, _rightPercent);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.rightView.width = Handle_W;
    self.rightView.right = self.width;
    self.leftView.left = 0;
    self.leftView.right = self.rightView.left;
}

- (void)currentLeft:(CGFloat)leftPercent rightPercent:(CGFloat)rightPercent {
     self.x = leftPercent * D_SCREEN_WIDTH ;
     self.width = rightPercent * D_SCREEN_WIDTH;
    if (self.right >= D_SCREEN_WIDTH) {
        self.right = D_SCREEN_WIDTH;
    }
    
    
}
 
@end
