//
//  RexPhotoItem.h
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/23.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RexPhoto.h"

@interface RexPhotoItem : UIView

@property (nonatomic, strong) UIScrollView * bgScrollView;
@property (nonatomic, strong) UIImageView * imageView;

- (void)setLocalImage:(NSString *)imageStr;
- (void)setNetworkImage:(NSString *)imageUrl placeholderImage:(id)image;

- (void)clearItem; 

@property (nonatomic,copy) void(^singleTapBlock)(UITapGestureRecognizer * sender);

@end
