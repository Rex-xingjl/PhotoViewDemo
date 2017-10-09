//
//  RexPhoto.h
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/23.
//  Copyright © 2017年 Rex. All rights reserved.
//

#ifndef RexPhoto_h
#define RexPhoto_h

#import "RexPhotoAlbum.h"

#define rexIsIPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)

#define rexNavBarHeight rexIsIPhoneX ? 88 : 64
#define rexTabBarHeight rexIsIPhoneX ? 83 : 49
#define rexStatusBarHeight rexIsIPhoneX ? 44 : 20

#define rexTopAndBtmTotalHeight (rexNavBarHeight + rexTabBarHeight)

#define rexHexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// spacing between horizontal items
#define kHorizonLineSpacing (30.f)
// spacing between vertical items
#define kVerticalItemSpacing (6.f)
// spacing between veritcal item and screen
#define kVerticalEdgeSpacing (9.f)

// horizontal scrollView frame
#define kAlbumHorizontalFrame CGRectMake( \
0, \
rexStatusBarHeight - 20.f, \
self.view.bounds.size.width + kHorizonLineSpacing, \
self.view.bounds.size.height - (rexStatusBarHeight-20.f + (rexTabBarHeight-49.f)) \
)

// vertical scrollView frame
#define kAlbumVerticalFrame CGRectMake( \
0, \
rexStatusBarHeight - 20.f, \
self.view.bounds.size.width, \
self.view.bounds.size.height - (rexStatusBarHeight-20.f+(rexTabBarHeight-49.f)) \
)

#define kPhotoItemWidth(number) (([UIScreen mainScreen].bounds.size.width - (kVerticalEdgeSpacing)*2 - (kVerticalItemSpacing)*(number-1))/number)

#define kAlbumWidth [UIScreen mainScreen].bounds.size.width
#define kAlbumHeight ([UIScreen mainScreen].bounds.size.height - (rexStatusBarHeight-20.f+(rexTabBarHeight-49.f)))

#define kTopMenuViewFrame CGRectMake(0, 0, kAlbumWidth, rexNavBarHeight)
#define kTopMenuViewFrame_hide CGRectMake(0, -(rexNavBarHeight), kAlbumWidth, rexNavBarHeight)
#define kBtmMenuViewFrame CGRectMake(0, kAlbumHeight - 155, kAlbumWidth, 155.f)
#define kBtmMenuViewFrame_hide CGRectMake(0, kAlbumHeight + 1.f + (rexTabBarHeight - 49.f), kAlbumWidth, 155.f)

#define kCloseBtnFrame CGRectMake(15.f, rexStatusBarHeight , 44.f, 44.f)
#define kCloseBtnImage @"closePhotoAlbum"

#define kChangeAlbumFrane CGRectMake(kAlbumWidth-44.f-15.f, rexStatusBarHeight, 44.f, 44.f)
#define kChangeAlbumImage @"changeAlbum"

// frame in BtmMenuView
#define kSaveImageBtnFrame CGRectMake(0, 0, 101.f, 33.f)
#define kSaveImageBtnTitle @"保存图片"

#define kBigBottomTitleFont [UIFont systemFontOfSize:17]
#define kSmallBottomTitleFont [UIFont systemFontOfSize:13]

#define kTitleLabelFont kDefaultFont
#define kIndexLabelFont kDefaultFont
#define kSaveImageBtnFont kDefaultFont

#define kDefaultFont [UIFont systemFontOfSize:14]

#define kTagSuffix (19680127)

#define kRexBundlePath(name) ([[[NSBundle mainBundle] pathForResource:@"RexPhotoAlbum" ofType:@"bundle"] stringByAppendingPathComponent:name])

#endif /* RexPhoto_h */
