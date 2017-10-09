//
//  RexPhotoCell.h
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/22.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RexPhotoItem.h"

@interface RexPhotoCell : UICollectionViewCell

@property (nonatomic, strong) RexPhotoItem * photoItem;

@end

@interface RexThumbnailCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * photoItem;

@property (nonatomic,copy) void(^singleTapBlock)(UITapGestureRecognizer * sender);

- (void)setNetworkImage:(NSString *)imageUrl placeholderImage:(id)image;

@end

@interface RexSectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel * titleLabel;

@end

@interface RexTitleView : UIView

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic,copy) void(^singleTapBlock)(UITapGestureRecognizer * sender);

@end


