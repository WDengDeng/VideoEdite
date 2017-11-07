//  StickerView
//  VideoEdite
//
//  Created by WDeng on 16/11/25.
//  Copyright © 2016年 WDeng. All rights reserved.
//

#import "StickerView.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import "UIView+Frame.h"

@interface StickerView ()

@property(nonatomic, strong) UIButton *deleteButton;
@property(nonatomic, strong) UIImageView *largeView;
@property(nonatomic, assign) CGFloat scale;
@property(nonatomic, assign) CGFloat arg;
@property(nonatomic, assign) CGPoint initialPoint;
@property(nonatomic, assign) CGFloat initialArg;
@property(nonatomic, assign) CGFloat initialScale;
@property(nonatomic, assign) CGRect videoContentRect;
@property(nonatomic, copy) NSString *filePath;

@property(nonatomic, strong) FLAnimatedImageView *imageView;

@end

@implementation StickerView


- (void)setVideoContentRect:(CGRect)videoContent;
{
    _videoContentRect = videoContent;
}

- (CGRect)getVideoContentRect
{
    return _videoContentRect;
}

- (CGRect)getInnerFrame
{
    return [_imageView.superview convertRect:_imageView.frame toView:_imageView.superview.superview];
}

- (CGFloat)getRotateAngle
{
    return _arg;
}

- (NSString *)getFilePath
{
    return _filePath;
}

+ (void)setActiveStickerView:(StickerView*)view
{
    static StickerView *activeView = nil;
    if(view != activeView)
    {
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        [activeView.superview bringSubviewToFront:activeView];
        
    
    }
}


#pragma mark - String
static inline BOOL isStringEmpty(NSString *value)
{
    BOOL result = FALSE;
    if (!value || [value isKindOfClass:[NSNull class]])
    {
        // null object
        result = TRUE;
    }
    else
    {
        NSString *trimedString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([value isKindOfClass:[NSString class]] && [trimedString length] == 0)
        {
            // empty string
            result = TRUE;
        }
    }
    
    return result;
}

- (id)initWithFilePath:(NSString *)path
{
    
    if (path.length)
    {
        _filePath = path;
        
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        return [self initWithGifData:gifData];
    }
    
    return nil;
}

- (id)initWithGifData:(NSData *)gifData
{
    self.isRote = YES;
    int gap = 32;
    UIImage *image = [UIImage imageWithContentsOfFile:_filePath];
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width + gap, image.size.height + gap)];
    
    if(self)
    {
        _imageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.center = self.center;
        _imageView.animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:gifData];
        

        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"video_edite_delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 28, 28);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _largeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _largeView.image = [UIImage imageNamed:@"video_edite_large"];
        _largeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _largeView.center = CGPointMake(_imageView.d_width + _imageView.frame.origin.x, _imageView.d_height + _imageView.frame.origin.y);
        [self addSubview:_largeView];
        
  
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (id)initWithImage:(UIImage *)image
{
    int gap = 32;
    self = [super initWithFrame:CGRectMake(0, 0, image.size.width+gap, image.size.height+gap)];
    self.isRote = YES;
    if(self)
    {
        _imageView = [[FLAnimatedImageView alloc] initWithImage:image];
        _imageView.layer.borderColor = [[UIColor blackColor] CGColor];
        _imageView.layer.cornerRadius = 3;
        _imageView.center = self.center;
        [self addSubview:_imageView];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"video_edite_delete"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(0, 0, 28, 28);
        _deleteButton.center = _imageView.frame.origin;
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
        
        _largeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _largeView.image = [UIImage imageNamed:@"video_edite_large"];
        _largeView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        _largeView.center = CGPointMake(_imageView.d_width + _imageView.frame.origin.x, _imageView.d_height + _imageView.frame.origin.y);
        
        [self addSubview:_largeView];
        
        
        _scale = 1;
        _arg = 0;
        
        [self initGestures];
    }
    return self;
}

- (void)initGestures
{
    _imageView.userInteractionEnabled = YES;
    _largeView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)]];
    [_imageView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)]];
    [_largeView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(circleViewDidPan:)]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView* view = [super hitTest:point withEvent:event];
    
    if(view == self)
    {
        return nil;
    }
    return view;
}

- (UIImageView*)imageView
{
    return _imageView;
}

- (void)pushedDeleteBtn:(id)sender
{
    if (_deleteFinishBlock)
    {
        _deleteFinishBlock(YES, self);
    }
    
    StickerView *nextTarget = nil;
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i = index+1; i < self.superview.subviews.count; ++i)
    {
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[StickerView class]])
        {
            nextTarget = (StickerView*)view;
            break;
        }
    }
    
    if(!nextTarget)
    {
        for(NSInteger i = index-1; i >= 0; --i)
        {
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[StickerView class]])
            {
                nextTarget = (StickerView*)view;
                break;
            }
        }
    }
    
    [[self class] setActiveStickerView:nextTarget];
    if ([self.delegate respondsToSelector:@selector(currentActive:)]) {
        [self.delegate currentActive:nextTarget];
    }
    [self removeFromSuperview];
}

- (void)setAvtive:(BOOL)active
{
    _deleteButton.hidden = !active;
    _largeView.hidden = !active;

    _imageView.layer.borderColor = [UIColor colorWithRed:26/255.0 green:204/255.0 blue:218/255.0 alpha:1].CGColor;
    _imageView.layer.borderWidth = (active) ? 2/_scale : 0;
}

- (void)isHiddenBorder:(BOOL)hidden {
    
    _imageView.layer.borderWidth = hidden ? 0 : 2/_scale;
    _deleteButton.hidden = hidden;
    _largeView.hidden = hidden;
    
}


- (void)setScale:(CGFloat)scaleX andScaleY:(CGFloat)scaleY
{
    _scale = MIN(scaleX, scaleY);
    self.transform = CGAffineTransformIdentity;
    _imageView.transform = CGAffineTransformMakeScale(scaleX, scaleY);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_imageView.d_width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_imageView.d_height + 32)) / 2;
    rct.size.width  = _imageView.d_width + 32;
    rct.size.height = _imageView.d_height + 32;
    self.frame = rct;
    
    _imageView.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    self.transform = CGAffineTransformMakeRotation(_arg);
    
    _imageView.layer.borderWidth = 1/_scale;
    _imageView.layer.cornerRadius = 3/_scale;
}

- (void)setScale:(CGFloat)scale
{
    [self setScale:scale andScaleY:scale];
}

- (void)viewDidTap:(UITapGestureRecognizer*)sender
{

    [[self class] setActiveStickerView:self];
    if ([self.delegate respondsToSelector:@selector(startTouchView:)]) {
        
        [self.delegate startTouchView:self];
    }
}

- (void)viewDidPan:(UIPanGestureRecognizer*)sender
{
    [[self class] setActiveStickerView:self];
    
    CGPoint p = [sender translationInView:self.superview];
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = self.center;
        
        if ([self.delegate respondsToSelector:@selector(moveView:)]) {
            
            [self.delegate moveView:self];
        }
        
    }  else if(sender.state == UIGestureRecognizerStateEnded)  {
        
        if ([self.delegate respondsToSelector:@selector(EndTouchView:)]) {
            [self.delegate EndTouchView:self];
        }
        
    }
    self.center = CGPointMake(_initialPoint.x + p.x, _initialPoint.y + p.y);
}

- (void)circleViewDidPan:(UIPanGestureRecognizer*)sender
{
    CGPoint p = [sender translationInView:self.superview];
    
    static CGFloat tmpR = 1;
    static CGFloat tmpA = 0;
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        _initialPoint = [self.superview convertPoint:_largeView.center fromView:_largeView.superview];
        
        CGPoint p = CGPointMake(_initialPoint.x - self.center.x, _initialPoint.y - self.center.y);
        tmpR = sqrt(p.x*p.x + p.y*p.y);
        tmpA = atan2(p.y, p.x);
        
        _initialArg = _arg;
        _initialScale = _scale;
    }
    
    p = CGPointMake(_initialPoint.x + p.x - self.center.x, _initialPoint.y + p.y - self.center.y);
    CGFloat R = sqrt(p.x*p.x + p.y*p.y);
    CGFloat arg = atan2(p.y, p.x);
    
    _arg   = self.isRote ? _initialArg + arg - tmpA : _arg;
    [self setScale:MAX(_initialScale * R / tmpR, 0.05)];
}

- (void)imageViewDefaultFrame {
    _imageView.frame = self.bounds;
}


@end
