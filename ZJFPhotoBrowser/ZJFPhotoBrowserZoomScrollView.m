//
//  ZJFPhotoBrowserZoomScrollView.m
//  ZJFPhotoBrowser
//
//  Created by JvanChow on 2016/10/20.
//  Copyright © 2016年 zoujianfeng. All rights reserved.
//

#import "ZJFPhotoBrowserZoomScrollView.h"
#import <DACircularProgress/DACircularProgressView.h>
#import "UIImageView+WebCache.h"

@interface ZJFPhotoBrowserZoomScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) DACircularProgressView *progressView;

@property (nonatomic, assign) CGRect mainScreenFrame;

@end

@implementation ZJFPhotoBrowserZoomScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.minimumZoomScale = 1.0f;
        self.maximumZoomScale = 3.0f;

        [self addSubview:self.imageView];

        self.mainScreenFrame = [UIScreen mainScreen].bounds;
    }

    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    [self setZoomScale:1.0 animated:NO];
    self.scrollEnabled = NO;

    if (!self.progressView.superview) {
        [self addSubview:self.progressView];
    }

    [self.progressView setProgress:0.0f];

    __weak typeof(self) weakSelf = self;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = ((CGFloat)receivedSize)/((CGFloat)expectedSize);
        if (weakSelf.progressView.progress < progress) {
            [weakSelf.progressView setProgress:progress animated:YES];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.progressView removeFromSuperview];
        if (image) {
            weakSelf.imageView.frame = [self getImageRectFromImage:image];
            [weakSelf.imageView setNeedsLayout];
        }
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // 延中心点缩放
    CGRect rect = self.imageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    if (rect.size.width < self.frame.size.width) {
        rect.origin.x = floorf((self.frame.size.width - rect.size.width) / 2.0);
    }

    if (rect.size.height < self.frame.size.height) {
        rect.origin.y = floorf((self.frame.size.height - rect.size.height) / 2.0);
    }

    self.imageView.frame = rect;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    if(touch.tapCount == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        CGPoint touchPoint = [touch locationInView:self.imageView];
        [self zoomDoubleTapWithPoint:touchPoint];
    }

    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)zoomDoubleTapWithPoint:(CGPoint)touchPoint {
    if(self.zoomScale > self.minimumZoomScale) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGFloat width = self.bounds.size.width / self.maximumZoomScale;
        CGFloat height = self.bounds.size.height / self.maximumZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - width / 2, touchPoint.y - height / 2, width, height) animated:YES];
    }
}

- (CGRect)getImageRectFromImage:(UIImage *)image {
    CGFloat widthRatio = self.mainScreenFrame.size.width / image.size.width;
    CGFloat heightRatio = self.mainScreenFrame.size.height / image.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * image.size.width;
    CGFloat height = scale * image.size.height;

    return CGRectMake((self.mainScreenFrame.size.width - width) / 2, (self.mainScreenFrame.size.height - height) / 2, width, height);
}

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }

    return _imageView;
}

- (DACircularProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake((self.mainScreenFrame.size.width - 35.f)/ 2, (self.mainScreenFrame.size.height - 35.f) / 2, 35.f, 35.f)];
        [_progressView setProgress:0.0f];
        _progressView.thicknessRatio = 0.1;
        _progressView.roundedCorners = NO;
        _progressView.trackTintColor = [UIColor colorWithWhite:0.2 alpha:1];
        _progressView.progressTintColor = [UIColor colorWithWhite:1.0 alpha:1];
    }
    
    return _progressView;
}


@end
