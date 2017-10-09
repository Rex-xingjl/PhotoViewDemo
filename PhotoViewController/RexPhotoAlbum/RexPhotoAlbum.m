//
//  RexPhotoAlbum.m
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/22.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "RexPhotoAlbum.h"
#import "RexPhotoCell.h"
#import "RexPhoto.h"

@interface RexPhotoAlbum () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) UICollectionView * horizontalCV;
@property (nonatomic, strong) UICollectionView * verticalCV;
@property (nonatomic, strong) UICollectionViewFlowLayout * horizontalLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout * verticalLayout;

@property (nonatomic, strong) UIView * topMenuView;
@property (nonatomic, strong) UIView * btmMenuView;

@property (nonatomic, strong) UIButton * directionButton;
@property (nonatomic, strong) UIButton * saveImageButton;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * indexLabel;
@property (nonatomic, strong) UIScrollView * titleSV;

@property (nonatomic, strong) UIImageView * transformImageView;

@property (nonatomic, assign) BOOL isVertical;

@property (nonatomic, assign) NSInteger allCount;

@end

@implementation RexPhotoAlbum

#pragma mark - Touch -

// 改变相册状态按钮
- (void)changeCollectioAction:(UIButton *)btn {
    if (!self.isVertical) {
        [self showVerticalAlbum:btn];
    } else {
        [self showHorizontalAlbum:btn withIndexPath:self.currentIndexPath animated:YES];
    }
}

// 竖向展示
- (void)showVerticalAlbum:(UIButton *)sender {
    self.isVertical = YES;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        ((UIButton *)sender).userInteractionEnabled = NO;
    } else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        ((UIGestureRecognizer *)sender).enabled = NO;
    }
    
    self.verticalCV.hidden = NO;
    self.closeButton.hidden = YES;
    self.btmMenuView.hidden = YES;
    [self.directionButton setImage:[UIImage imageWithContentsOfFile:kRexBundlePath(kCloseBtnImage)] forState:0];
    [self.view sendSubviewToBack:self.horizontalCV];
    
    if ([self.verticalCV numberOfSections]) {
        [self.verticalCV scrollToItemAtIndexPath:self.currentIndexPath
                                atScrollPosition:UICollectionViewScrollPositionCenteredVertically
                                        animated:NO];
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        self.verticalCV.alpha = 1;
    } completion:^(BOOL finished) {
        self.horizontalCV.alpha = 0;
        self.horizontalCV.hidden = YES;
        if ([sender isKindOfClass:[UIButton class]]) {
            ((UIButton *)sender).userInteractionEnabled = YES;
        } else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
            ((UIGestureRecognizer *)sender).enabled = YES;
        }
    }];
}

- (void)showHorizontalAlbum:(id)sender withIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    self.isVertical = NO;
    
    if ([sender isKindOfClass:[UIButton class]]) {
        ((UIButton *)sender).userInteractionEnabled = NO;
    } else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
        ((UIGestureRecognizer *)sender).enabled = NO;
    }
    
    self.horizontalCV.hidden = NO;
    self.closeButton.hidden = NO;
    self.btmMenuView.hidden = NO;
    self.btmMenuView.alpha = 0;
    [self.directionButton setImage:[UIImage imageWithContentsOfFile:kRexBundlePath(kChangeAlbumImage)] forState:0];
    [self changeOldTitle:self.currentIndexPath withNewTitle:indexPath];
    [self.view sendSubviewToBack:self.verticalCV];
    
    if ([self.horizontalCV numberOfSections]) {
        [self.horizontalCV scrollToItemAtIndexPath:self.currentIndexPath
                                atScrollPosition:UICollectionViewScrollPositionLeft
                                        animated:NO];
    }
    
    [UIView animateWithDuration:animated ? 0.35 : 0 animations:^{
        self.horizontalCV.alpha = 1;
    } completion:^(BOOL finished) {
        self.verticalCV.alpha = 0;
        self.verticalCV.hidden = YES;
        if ([sender isKindOfClass:[UIButton class]]) {
            ((UIButton *)sender).userInteractionEnabled = YES;
        } else if ([sender isKindOfClass:[UIGestureRecognizer class]]) {
            ((UIGestureRecognizer *)sender).enabled = YES;
        }
    }];
    [UIView animateWithDuration:0.35 animations:^{
        self.btmMenuView.alpha = 1;
    }];
}

// 关闭相册
- (void)closeAlbumAction:(UIButton *)btn {
    if ([self.navigationController popViewControllerAnimated:YES] == nil) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)saveImageBtnAction:(UIButton *)btn {
    RexPhotoCell * cell = (RexPhotoCell *)[self.horizontalCV cellForItemAtIndexPath:self.currentIndexPath];
    UIImageWriteToSavedPhotosAlbum(cell.photoItem.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

// 大图item单击事件
- (void)horizontalItemTouchAction:(UITapGestureRecognizer *)tap {
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] init];
    }
    tap.enabled = NO;
    self.hideTopAndBtnView =  !self.hideTopAndBtnView;
    [UIView animateWithDuration:self.hideTopAndBtnView ? 0.20f : 0.35f animations:^{
        self.topMenuView.alpha = self.hideTopAndBtnView ? 0 : 1;
        self.btmMenuView.alpha = self.hideTopAndBtnView ? 0 : 1;
    } completion:^(BOOL finished) {
        tap.enabled = YES;
    }];
}

// 缩略图item点击事件
- (void)verticalItemTouchAction:(UITapGestureRecognizer *)tap indexPath:(NSIndexPath *)indexPath {
    if (!tap) {
        tap = [[UITapGestureRecognizer alloc] init];
    }
    tap.enabled = NO;
    UIImage * tapImage = ((UIImageView *)tap.view).image;
    self.transformImageView.image = tapImage;
    self.transformImageView.frame = [tap.view convertRect:tap.view.bounds toView:self.view];
    [self.view addSubview:self.transformImageView];
    [UIView animateWithDuration:0.3 animations:^{
        self.transformImageView.frame = kAlbumVerticalFrame;
    } completion:^(BOOL finished) {
        [self showHorizontalAlbum:tap withIndexPath:indexPath animated:NO];
        [self changeOldTitle:self.currentIndexPath withNewTitle:indexPath];
        [_transformImageView removeFromSuperview];
        _transformImageView = nil;
        tap.enabled = YES;
    }];
}

// 底部titleView点击事件
- (void)bottomTitleViewTapAction:(UITapGestureRecognizer *)tap viewTag:(NSInteger)tag {
    NSIndexPath * oldIndexPath = self.currentIndexPath;
    self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:tag - kTagSuffix];
    [self changeOldTitle:oldIndexPath withNewTitle:self.currentIndexPath];
    [self.horizontalCV scrollToItemAtIndexPath:self.currentIndexPath
                              atScrollPosition:UICollectionViewScrollPositionLeft
                                      animated:[self scrollViewCanAnimated:oldIndexPath]];
}

// 判断是否展示滚动动画效果 仅两张图挨着时才有滚动动画
- (BOOL)scrollViewCanAnimated:(NSIndexPath *)oldIndexPath {
    BOOL animated;
    NSInteger numberInOldSection = [self collectionView:self.horizontalCV
                                 numberOfItemsInSection:oldIndexPath.section];
    NSInteger numberInNewSection = [self collectionView:self.horizontalCV
                                 numberOfItemsInSection:self.currentIndexPath.section];
    BOOL can1 = oldIndexPath.row + 1 == numberInOldSection &&
    (self.currentIndexPath.section - oldIndexPath.section == 1);
    BOOL can2 = self.currentIndexPath.row == 0 &&
    (oldIndexPath.section - self.currentIndexPath.section == 1) &&
    numberInNewSection == 1;
    animated = can1 || can2;
    return animated;
}

#pragma mark - View Life Cycle -

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor blackColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self.view addSubview:self.horizontalCV];
    [self.view addSubview:self.verticalCV];
    [self.view addSubview:self.topMenuView];
    [self.view addSubview:self.btmMenuView];
    [self initStation];
}

- (void)initStation {
    NSInteger maxSectionCount = [self numberOfSectionsInCollectionView:self.horizontalCV];
    if (self.currentIndexPath.section + 1 > maxSectionCount) {
        self.currentIndexPath = [NSIndexPath indexPathForItem:0 inSection:maxSectionCount-1 < 0 ? 0 : maxSectionCount-1];
        NSLog(@"[RexPhotoAlbum >> currentIndexPath.section 超出数据最大值，默认设为最大值]");
    } else {
        NSInteger maxItemCount = [self collectionView:self.horizontalCV numberOfItemsInSection:self.currentIndexPath.section];
        if (self.currentIndexPath.row + 1 > maxItemCount) {
        self.currentIndexPath = [NSIndexPath indexPathForItem:maxItemCount-1 < 0 ? 0 : maxItemCount-1 inSection:self.currentIndexPath.section];
        NSLog(@"[RexPhotoAlbum >> currentIndexPath.row 超出数据最大值，默认设为最大值]");
        }
    }
    if (self.showVerticalFirst) {
        [self showVerticalAlbum:nil];
    } else {
        [self verticalItemTouchAction:nil indexPath:self.currentIndexPath];
    }
}

#pragma mark - Delegate Response Method -

- (NSString *)titleForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(photoAlbum:titleForSection:)]) {
        return [self.delegate photoAlbum:self titleForSection:section];
    }
    return nil;
}

- (NSString *)itemTitleForIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(photoAlbum:titleForItemAtIndex:)]) {
        return [self.delegate photoAlbum:self titleForItemAtIndex:indexPath];
    }
    return nil;
}

- (NSString *)thumbnailUrlForIndexPath:(NSIndexPath *)index {
    if ([self.delegate respondsToSelector:@selector(photoAlbum:thumbnailUrlForIndex:)]) {
        return [self.delegate photoAlbum:self thumbnailUrlForIndex:index];
    }
    return nil;
}

- (NSString *)thumbnailNameForIndexPath:(NSIndexPath *)index {
    if ([self.delegate respondsToSelector:@selector(photoAlbum:thumbnailNameForIndex:)]) {
        return [self.delegate photoAlbum:self thumbnailNameForIndex:index];
    }
    return nil;
}

- (NSString *)imageURLForIndexPath:(NSIndexPath *)index{
    if ([self.delegate respondsToSelector:@selector(photoAlbum:imageURLForIndex:)]) {
        return [self.delegate photoAlbum:self imageURLForIndex:index];
    }
    return nil;
}

- (NSString *)imageNameForIndexPath:(NSIndexPath *)index {
    if ([self.delegate respondsToSelector:@selector(photoAlbum:imageNameForIndex:)]) {
        return [self.delegate photoAlbum:self imageNameForIndex:index];
    }
    return nil;
}

- (id)placeholderForThumbnail {
    if ([self.delegate respondsToSelector:@selector(placeholderForThumbnailWithPhotoAlbum:)]) {
        return [self.delegate placeholderForThumbnailWithPhotoAlbum:self];
    }
    return nil;
}

- (id)placeholderForImage {
    if ([self.delegate respondsToSelector:@selector(placeholderForImageWithPhotoAlbum:)]) {
        return [self.delegate placeholderForImageWithPhotoAlbum:self];
    }
    return nil;
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(id)contextInfo {
    if ([self.delegate respondsToSelector:@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:)]) {
        [self.delegate imageSavedToPhotosAlbum:image didFinishSavingWithError:error contextInfo:contextInfo];
    }
}

#pragma mark - UICollectionViewDataSource -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if ([self.delegate respondsToSelector:@selector(numberOfSectionsInAlbum:)]) {
        return [self.delegate numberOfSectionsInAlbum:self];
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(photoAlbum:numberofItemsInSection:)]) {
        if (collectionView == self.titleSV) {
            return 1;
        } else {
            return [self.delegate photoAlbum:self numberofItemsInSection:section];
        }
    }
    return 0;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    if (collectionView == self.verticalCV &&
        kind == UICollectionElementKindSectionHeader) {
        RexSectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"RexSectionReusableView" forIndexPath:indexPath];
        view.titleLabel.text = [self titleForSection:indexPath.section];
        return view;
    }
    return nil;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.horizontalCV) {
        RexPhotoCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RexPhotoCell" forIndexPath:indexPath];
        if ([self imageURLForIndexPath:indexPath]) {
            [cell.photoItem setNetworkImage:[self imageURLForIndexPath:indexPath]
                           placeholderImage:[self placeholderForImage]];
        } else if ([self imageNameForIndexPath:indexPath]) {
            [cell.photoItem setLocalImage:[self imageNameForIndexPath:indexPath]];
        } else {
            [cell.photoItem setLocalImage:@""];
        }
        cell.photoItem.singleTapBlock = ^(UITapGestureRecognizer * tap){
            [self horizontalItemTouchAction:tap];
        };
        return cell;
    } else if (collectionView == self.verticalCV) {
        RexThumbnailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RexThumbnailCell" forIndexPath:indexPath];
        if ([self thumbnailUrlForIndexPath:indexPath]) {
            [cell setNetworkImage:[self thumbnailUrlForIndexPath:indexPath]
                 placeholderImage:[self placeholderForThumbnail]];
        } else if ([self thumbnailNameForIndexPath:indexPath]) {
            [cell.photoItem setImage:[UIImage imageNamed:[self thumbnailNameForIndexPath:indexPath]]];
        } else {
            [cell.photoItem setImage:nil];
        }
        cell.singleTapBlock = ^(UITapGestureRecognizer * tap){
            NSIndexPath * oldIndexPath = self.currentIndexPath;
            self.currentIndexPath = indexPath;
            [self changeOldTitle:oldIndexPath withNewTitle:self.currentIndexPath];
            [self verticalItemTouchAction:tap indexPath:indexPath];
        };
        return cell;
    } else {
        return [[UICollectionViewCell alloc] init];
    }
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.horizontalCV) {
        NSIndexPath * oldIndexPath = self.currentIndexPath;
        CGPoint centerPoint  = [self.view convertPoint:self.horizontalCV.center toView:self.horizontalCV];
        NSIndexPath *indexPath = [self.horizontalCV indexPathForItemAtPoint:centerPoint];
        self.currentIndexPath = indexPath;
        [self changeOldTitle:oldIndexPath withNewTitle:self.currentIndexPath];
    }
}

- (void)changeOldTitle:(NSIndexPath *)oldIndexPath withNewTitle:(NSIndexPath *)newIndexPath {
    RexTitleView * oldView = [self.titleSV viewWithTag:(oldIndexPath.section+kTagSuffix)];
    oldView.titleLabel.font = kSmallBottomTitleFont;
    RexTitleView * newView = [self.titleSV viewWithTag:(newIndexPath.section+kTagSuffix)];
    newView.titleLabel.font = kBigBottomTitleFont;
    [self.titleSV scrollRectToVisible:newView.frame animated:YES];
    self.titleLabel.text = [self itemTitleForIndexPath:newIndexPath];
    self.indexLabel.text = [self makeIndexToAlubm:newIndexPath];
}

- (NSString *)makeIndexToAlubm:(NSIndexPath *)newIndexPath {
    if (self.showIndexInSection) {
        return [NSString stringWithFormat:@"%ld/%ld", (long)(newIndexPath.row + 1), (long)[self collectionView:self.horizontalCV numberOfItemsInSection:newIndexPath.section]];
    } else {
        if (self.allCount == 0) {
            for (int i = 0; i < [self numberOfSectionsInCollectionView:self.horizontalCV]; i ++) {
                self.allCount += [self collectionView:self.horizontalCV numberOfItemsInSection:i];
            }
        }
        NSInteger current = 0;
        for (int i = 0; i <= newIndexPath.section-1; i ++) {
            current += [self collectionView:self.horizontalCV numberOfItemsInSection:i];
        }
        current += newIndexPath.row+1;
        NSLog(@"%ld, %ld", current, self.allCount);
        return [NSString stringWithFormat:@"%ld/%ld", current, self.allCount];
    }
}

#pragma mark - Lazy Load -

- (NSInteger)numberOfRowsInOneLine {
    if (!_numberOfRowsInOneLine) {
        _numberOfRowsInOneLine = 3;
    }
    return _numberOfRowsInOneLine;
}

- (UIImageView *)transformImageView {
    if (!_transformImageView) {
        self.transformImageView = [[UIImageView alloc] init];
        _transformImageView.backgroundColor = [UIColor blackColor];
        _transformImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _transformImageView;
}

- (UICollectionViewFlowLayout *)horizontalLayout {
    if (!_horizontalLayout) {
        self.horizontalLayout = [[UICollectionViewFlowLayout alloc] init];
        _horizontalLayout.minimumLineSpacing = kHorizonLineSpacing;
        _horizontalLayout.minimumInteritemSpacing = 0;
        _horizontalLayout.itemSize = CGSizeMake(kAlbumWidth, kAlbumHeight);
        _horizontalLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _horizontalLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, kHorizonLineSpacing);
    }
    return _horizontalLayout;
}

- (UICollectionViewFlowLayout *)verticalLayout {
    if (!_verticalLayout) {
        self.verticalLayout = [[UICollectionViewFlowLayout alloc] init];
        _verticalLayout.minimumLineSpacing = kVerticalItemSpacing;
        _verticalLayout.minimumInteritemSpacing = kVerticalItemSpacing;
        _verticalLayout.itemSize = CGSizeMake(kPhotoItemWidth(self.numberOfRowsInOneLine), kPhotoItemWidth(self.numberOfRowsInOneLine)*70.f/115.f);
        _verticalLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _verticalLayout.sectionInset = UIEdgeInsetsMake(0, kVerticalEdgeSpacing, 5, kVerticalEdgeSpacing);
        _verticalLayout.headerReferenceSize = CGSizeMake(kAlbumWidth - 40, 40);
    }
    return _verticalLayout;
}

- (UICollectionView *)horizontalCV {
    if (!_horizontalCV) {
        self.horizontalCV = [[UICollectionView alloc] initWithFrame:kAlbumHorizontalFrame
                                                      collectionViewLayout:self.horizontalLayout];
        _horizontalCV.backgroundColor = [UIColor blackColor];
        _horizontalCV.dataSource = self;
        _horizontalCV.delegate = self;
        _horizontalCV.pagingEnabled = YES;
        _horizontalCV.showsVerticalScrollIndicator = NO;
        _horizontalCV.showsHorizontalScrollIndicator = NO;
        _horizontalCV.layer.masksToBounds = YES;
        [_horizontalCV registerClass:[RexPhotoCell class]
              forCellWithReuseIdentifier:@"RexPhotoCell"];
    }
    return _horizontalCV;
}

- (UICollectionView *)verticalCV {
    if (!_verticalCV) {
        self.verticalCV = [[UICollectionView alloc] initWithFrame:kAlbumVerticalFrame
                                               collectionViewLayout:self.verticalLayout];
        _verticalCV.backgroundColor = [UIColor blackColor];
        _verticalCV.dataSource = self;
        _verticalCV.delegate = self;
        _verticalCV.pagingEnabled = NO;
        _verticalCV.showsVerticalScrollIndicator = NO;
        _verticalCV.showsHorizontalScrollIndicator = NO;
        _verticalCV.contentInset = UIEdgeInsetsMake(60, 0, 30, 0);
        _verticalCV.layer.masksToBounds = YES;
        [_verticalCV registerClass:[RexThumbnailCell class]
            forCellWithReuseIdentifier:@"RexThumbnailCell"];
        [_verticalCV registerClass:[RexSectionReusableView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"RexSectionReusableView"];
    }
    return _verticalCV;
}

- (UIView *)topMenuView {
    if (!_topMenuView) {
        self.topMenuView = [[UIView alloc] initWithFrame:kTopMenuViewFrame];
        if (!_closeButton) {
            [self initCloseButton];
        }
        [_topMenuView addSubview:self.closeButton];
        [_topMenuView addSubview:self.directionButton];
    }
    return _topMenuView;
}

- (UIView *)btmMenuView {
    if (!_btmMenuView) {
        self.btmMenuView = [[UIView alloc] initWithFrame:kBtmMenuViewFrame];
        [_btmMenuView addSubview:self.saveImageButton];
        [_btmMenuView addSubview:self.titleSV];
    
        UIView * labelBgView = [[UIView alloc] initWithFrame:CGRectMake(0, kBtmMenuViewFrame.size.height-97, kAlbumWidth, 60)];
        [labelBgView addSubview:self.titleLabel];
        [labelBgView addSubview:self.indexLabel];
        labelBgView.backgroundColor = [rexHexRGB(0x00000) colorWithAlphaComponent:0.5];
        [_btmMenuView addSubview:labelBgView];
    }
    return _btmMenuView;
}

- (void)initCloseButton {
    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeButton.frame = kCloseBtnFrame;
    [_closeButton setImage:[UIImage imageWithContentsOfFile:kRexBundlePath(kCloseBtnImage)] forState:0];
    [_closeButton addTarget:self
                     action:@selector(closeAlbumAction:)
           forControlEvents:UIControlEventTouchUpInside];
}

- (UIButton *)directionButton {
    if (!_directionButton) {
        self.directionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _directionButton.frame = kChangeAlbumFrane;
        [_directionButton setImage:[UIImage imageWithContentsOfFile:kRexBundlePath(kChangeAlbumImage)] forState:0];
        [_directionButton addTarget:self
                             action:@selector(changeCollectioAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _directionButton;
}

- (UIButton *)saveImageButton {
    if (!_saveImageButton) {
        self.saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveImageButton setFrame:CGRectMake(0, 0, 101, 33)];
        [_saveImageButton setCenter:CGPointMake(self.btmMenuView.center.x, 20)];
        [_saveImageButton setTitle:kSaveImageBtnTitle forState:0];
        [_saveImageButton setBackgroundColor:[rexHexRGB(0x252525) colorWithAlphaComponent:0.3]];
        [_saveImageButton.titleLabel setFont:kSaveImageBtnFont];
        [_saveImageButton.layer setBorderColor:[rexHexRGB(0x9B9B9B) colorWithAlphaComponent:0.4].CGColor];
        [_saveImageButton.layer setBorderWidth:0.8];
        [_saveImageButton.layer setCornerRadius:2.f];
        [_saveImageButton.layer setMasksToBounds:YES];
        [_saveImageButton addTarget:self action:@selector(saveImageBtnAction:)
                   forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveImageButton;
}

- (UIScrollView *)titleSV {
    if (!_titleSV) {
        self.titleSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kBtmMenuViewFrame.size.height - 37, kAlbumWidth, 37)];
        _titleSV.backgroundColor = [rexHexRGB(0x1F1F1F) colorWithAlphaComponent:0.9];
        _titleSV.delegate = self;
        _titleSV.pagingEnabled = NO;
        _titleSV.showsVerticalScrollIndicator = NO;
        _titleSV.showsHorizontalScrollIndicator = NO;
        
        NSInteger sectionNumber =  [self numberOfSectionsInCollectionView:self.horizontalCV];
        _titleSV.contentSize = CGSizeMake(kAlbumWidth/3 * sectionNumber + 1, 37);
        for (int i = 0; i < sectionNumber ; i ++) {
            RexTitleView * view = [[RexTitleView alloc] initWithFrame:CGRectMake(i * kAlbumWidth/3, 0, kAlbumWidth/3, 37)];
            view.tag = i + kTagSuffix;
            view.titleLabel.text = [self titleForSection:i];
            [self.titleSV addSubview:view];
            __weak typeof(view) weakview = view;
            view.singleTapBlock = ^(UITapGestureRecognizer *sender) {
                [self bottomTitleViewTapAction:sender viewTag:weakview.tag];
            };
        }
    }
    return _titleSV;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kAlbumWidth-60, 60)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = kTitleLabelFont;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        self.indexLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame), 0, 50, 60)];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = kIndexLabelFont;
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

@end
