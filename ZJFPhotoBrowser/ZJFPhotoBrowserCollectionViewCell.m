//
//  ZJFPhotoBrowserCollectionViewCell.m
//  ZJFPhotoBrowser
//
//  Created by JvanChow on 2016/10/20.
//  Copyright © 2016年 zoujianfeng. All rights reserved.
//

#import "ZJFPhotoBrowserCollectionViewCell.h"
#import "ZJFPhotoBrowserZoomScrollView.h"

@interface ZJFPhotoBrowserCollectionViewCell ()

@property (nonatomic, strong) ZJFPhotoBrowserZoomScrollView *zoomScrollView;

@end

@implementation ZJFPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.zoomScrollView];
    }

    return self;
}

- (void)setImageUrl:(NSString *)imageUrl {
    [self.zoomScrollView setImageUrl:imageUrl];
}

#pragma mark - getter

- (ZJFPhotoBrowserZoomScrollView *)zoomScrollView {
    if (!_zoomScrollView) {
        CGRect rect = self.contentView.bounds;
        rect.size.width = [UIScreen mainScreen].bounds.size.width;
        _zoomScrollView = [[ZJFPhotoBrowserZoomScrollView alloc] initWithFrame:rect];
    }

    return _zoomScrollView;
}

@end
