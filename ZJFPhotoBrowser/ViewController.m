//
//  ViewController.m
//  ZJFPhotoBrowser
//
//  Created by JvanChow on 2016/10/20.
//  Copyright © 2016年 zoujianfeng. All rights reserved.
//

#import "ViewController.h"
#import "ZJFPhotoBrowserCollectionViewCell.h"

NSUInteger const kCollectionViewMargin = 10;

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *photoUrls;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.collectionView];

    self.photoUrls = @[@"http://image.17173.com/bbs/v1/2011/07/22/1311319985863.jpg",
                       @"http://gb.cri.cn/mmsource/images/2006/06/08/sz060608014.jpg",
                       @"http://www.jxgdw.com/articleimage/2005-06-23/xiaoluo2.jpg",
                       @"http://www.hinews.cn/pic/0/16/72/73/16727368_321640.jpg",
                       @"http://d.hiphotos.baidu.com/zhidao/pic/item/4b90f603738da9775a971738b051f8198618e36d.jpg",
                       @"http://www.cnr.cn/sports/syt/W020060308503208711867.jpg",
                       @"http://img3.cache.netease.com/photo/0005/2009-12-01/5PEM07PE00DE0005.jpg",
                       @"http://sports.cctv.com/20080926/images/1222389645694_1222389645694_r.jpg",
                       @"http://s.news.bandao.cn/news_upload/200809/20080902082155_M5KO1YB9.jpg",
                       @"http://photocdn.sohu.com/20130124/Img364496570.jpg",
                       @"http://img3.cache.netease.com/photo/0074/2008-08-21/4JSUEPHD05NN0074.jpg",
                       @"http://ww1.sinaimg.cn/bmiddle/4ffbcf0ajw1emjrrzp97uj20qq0f043v.jpg"];

    [self.collectionView reloadData];
}

#pragma mark - collectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoUrls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZJFPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZJFPhotoBrowserCollectionViewCell" forIndexPath:indexPath];
    [cell setImageUrl:self.photoUrls[indexPath.item]];

    return cell;
}

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(self.view.frame.size.width + kCollectionViewMargin, self.view.frame.size.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;

        CGRect rect = self.view.bounds;
        rect.size.width += kCollectionViewMargin;
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[ZJFPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"ZJFPhotoBrowserCollectionViewCell"];
    }

    return _collectionView;
}

@end
