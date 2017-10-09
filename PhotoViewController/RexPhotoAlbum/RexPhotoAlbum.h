//
//  RexPhotoAlbum.h
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/22.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RexAlbumDirectionHorizontal = 0,
    RexAlbumDirectionVertical,
} RexAlbumDirection;

@class RexPhotoAlbum;
@protocol RexPhotoAlbumDelegate <NSObject>

@required
- (NSInteger)numberOfSectionsInAlbum:(RexPhotoAlbum *)album;
- (NSInteger)photoAlbum:(RexPhotoAlbum *)album numberofItemsInSection:(NSInteger)section;

@optional
- (NSString *)photoAlbum:(RexPhotoAlbum *)album titleForSection:(NSInteger)section;
- (NSString *)photoAlbum:(RexPhotoAlbum *)album titleForItemAtIndex:(NSIndexPath *)indexPath;

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(id)contextInfo;

// network image
- (NSString *)photoAlbum:(RexPhotoAlbum *)album thumbnailUrlForIndex:(NSIndexPath *)indexPath;
- (NSString *)photoAlbum:(RexPhotoAlbum *)album imageURLForIndex:(NSIndexPath *)indexPath;
- (id)placeholderForThumbnailWithPhotoAlbum:(RexPhotoAlbum *)album;
- (id)placeholderForImageWithPhotoAlbum:(RexPhotoAlbum *)album;

// local image
- (NSString *)photoAlbum:(RexPhotoAlbum *)album thumbnailNameForIndex:(NSIndexPath *)indexPath;
- (NSString *)photoAlbum:(RexPhotoAlbum *)album imageNameForIndex:(NSIndexPath *)indexPath;

@end

@interface RexPhotoAlbum : UIViewController

@property (nonatomic, weak) id <RexPhotoAlbumDelegate> delegate;
@property (nonatomic, assign) BOOL showVerticalFirst; // default is NO.
@property (nonatomic, assign) BOOL hideTopAndBtnView; // default is NO.
@property (nonatomic, assign) NSInteger numberOfRowsInOneLine; // default is 3.
@property (nonatomic, strong) NSIndexPath * currentIndexPath; // horizontal、vertical album and bottom scrollView.
@property (nonatomic, assign) BOOL showIndexInSection;  // default is NO.

@end

