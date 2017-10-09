//
//  RexPhotoCell.m
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/22.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "RexPhotoCell.h"
#import "UIImageView+WebCache.h"

@implementation RexPhotoCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initPhotoCell];
    }
    return self;
}

- (RexPhotoItem *)photoItem {
    if (!_photoItem) {
        self.photoItem = [[RexPhotoItem alloc] initWithFrame:self.bounds];
    }
    return _photoItem;
}

- (void)initPhotoCell {
    [self.contentView addSubview:self.photoItem];
}

@end

@implementation RexThumbnailCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initPhotoCell];
    }
    return self;
}

- (UIImageView *)photoItem {
    if (!_photoItem) {
        self.photoItem = [[UIImageView alloc] initWithFrame:self.bounds];
        _photoItem.contentMode = UIViewContentModeScaleAspectFill;
        _photoItem.clipsToBounds = YES;
        _photoItem.layer.masksToBounds = YES;
        _photoItem.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [_photoItem addGestureRecognizer:singleTap];

    }
    return _photoItem;
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 1) {
        if (self.singleTapBlock) {
            self.singleTapBlock(tap);
        }
    }
}

- (void)initPhotoCell {
    self.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.photoItem];
}

- (void)setNetworkImage:(NSString *)imageUrl placeholderImage:(id)image {
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
    [self.photoItem sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                      placeholderImage:placeholderImage
                               options:SDWebImageProgressiveDownload];
}

@end

@implementation RexSectionReusableView

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kVerticalEdgeSpacing, kVerticalItemSpacing, self.bounds.size.width-(kVerticalEdgeSpacing*2), self.bounds.size.height-kVerticalItemSpacing)];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = kDefaultFont;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [_titleLabel addGestureRecognizer:singleTap];
    }
    return _titleLabel;
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 1) {

    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initTitleView];
    }
    return self;
}

- (void)initTitleView {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
}

@end

@implementation RexTitleView

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = kSmallBottomTitleFont;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        singleTap.numberOfTapsRequired = 1;
        [_titleLabel addGestureRecognizer:singleTap];
    }
    return _titleLabel;
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    if (tap.numberOfTapsRequired == 1) {
        if (self.singleTapBlock) {
            self.singleTapBlock(tap);
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initTitleView];
    }
    return self;
}

- (void)initTitleView {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleLabel];
}

@end
