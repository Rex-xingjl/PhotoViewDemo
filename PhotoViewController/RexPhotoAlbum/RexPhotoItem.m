//
//  RexPhotoItem.m
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/23.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "RexPhotoItem.h"
#import "UIImageView+WebCache.h"

@interface RexPhotoItem () <UIScrollViewDelegate>

@end

@implementation RexPhotoItem {
    CGFloat lastPosition;
}

#pragma mark - Method -

- (void)setLocalImage:(NSString *)imageStr {
    [self clearItem];
    [self.imageView setImage:[UIImage imageNamed:imageStr]];
}

- (void)setNetworkImage:(NSString *)imageUrl placeholderImage:(id)image {
    [self clearItem];
    UIImage * placeholderImage;
    if ([image isKindOfClass:[NSString class]]) {
        placeholderImage = [UIImage imageNamed:image];
    } else if ([image isKindOfClass:[UIImage class]]) {
        placeholderImage = image;
    } else {
        placeholderImage = nil;
    }
    if (!imageUrl) {
        return;
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                      placeholderImage:placeholderImage
                               options:SDWebImageProgressiveDownload];
}

- (void)clearItem {
    [_bgScrollView removeFromSuperview];
    _bgScrollView = nil;
    _imageView = nil;
    [self addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.imageView];
}

#pragma mark - Touch -

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 1) {
        if (self.singleTapBlock) {
            self.singleTapBlock(tap);
        }
    }
}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 2) {
        NSInteger times = _bgScrollView.zoomScale == 1 ? 2 : 0.5;
        float newScale = [_bgScrollView zoomScale] * times;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tap locationInView:tap.view]];
        [_bgScrollView zoomToRect:zoomRect animated:YES];
    }
}

- (void)twoFingerTapAction:(UITapGestureRecognizer *)tap {
    float newScale = [_bgScrollView zoomScale]/2;
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[tap locationInView:tap.view]];
    [_bgScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - UIScrollViewDelegate -

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    for (UIView * view in scrollView.subviews){
        return view;
    }
    return nil;
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    [scrollView setZoomScale:scale+0.01 animated:NO];
    [scrollView setZoomScale:scale animated:NO];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center {
    CGRect zoomRect;
    zoomRect.size.height = [_bgScrollView frame].size.height/scale;
    zoomRect.size.width = [_bgScrollView frame].size.width/scale;
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    return zoomRect;
}

#pragma mark - Init -

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

#pragma mark - Lazy Load -

- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        self.bgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _bgScrollView.delegate = self;
        _bgScrollView.minimumZoomScale = 1;
        _bgScrollView.maximumZoomScale = 3;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.zoomScale = 1;
        _bgScrollView.bounces = NO;
    }
    return _bgScrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        UITapGestureRecognizer *twoFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
        twoFingerTap.numberOfTouchesRequired = 2;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [_imageView addGestureRecognizer:singleTap];
        [_imageView addGestureRecognizer:doubleTap];
        [_imageView addGestureRecognizer:twoFingerTap];
    }
    return _imageView;
}

@end
