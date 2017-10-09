//
//  ViewController.m
//  PhotoViewController
//
//  Created by Rex@JJS on 2017/9/22.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ViewController.h"
#import "RexPhotoAlbum.h"

@interface ViewController () <RexPhotoAlbumDelegate>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * imageStrArray;
@property (nonatomic, strong) NSArray * sectionTitleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.imageStrArray = @[@[@"0", @"timg-0",@"1"],
                                @[ @"timg-1"],
                                @[@"2",@"timg-2", @"3",@"timg-3"],
                                @[@"4"],
                                @[@"timg-4", @"5", @"timg-5", @"6",@"timg-6"],
                                @[@"7",@"timg-7"]];
    self.titleArray = @[@"户型图-1 56 m2 ",@"户型图-2 73m2 ",@"户型图-3 82m2 ",@"户型图-4 76m2 ",@"户型图-5 33m2 ",@"户型图-6 100m2 ",@"户型图-7 135m2 ",@"户型图-8 96m2 "];
    self.sectionTitleArray = @[@"56m2 ",@"73m2 ",@"82m2 ",@"76m2 ",@"33m2 ",@"100m2 ",@"135m2 ",@"96m2 "];
}

- (IBAction)previewBtnAction:(UIButton *)sender {
    
    RexPhotoAlbum * vc = [[RexPhotoAlbum alloc] init];
    vc.delegate = self;
//    vc.showVerticalFirst = 1;
//    vc.currentIndexPath = [NSIndexPath indexPathForItem:2 inSection:3];
    [self presentViewController:vc animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInAlbum:(RexPhotoAlbum *)album {
        return self.imageStrArray.count;
}

- (NSString *)photoAlbum:(RexPhotoAlbum *)album titleForSection:(NSInteger)section {
    return self.sectionTitleArray[section];
}

- (NSString *)photoAlbum:(RexPhotoAlbum *)album titleForItemAtIndex:(NSIndexPath *)indexPath{
    return self.titleArray[indexPath.section];
}

- (NSInteger)photoAlbum:(RexPhotoAlbum *)album numberofItemsInSection:(NSInteger)section {
    return [self.imageStrArray[section] count];
}

- (NSString *)photoAlbum:(RexPhotoAlbum *)album thumbnailNameForIndex:(NSIndexPath *)indexPath {
    return self.imageStrArray[indexPath.section][indexPath.row];;
}

- (NSString *)photoAlbum:(RexPhotoAlbum *)album imageNameForIndex:(NSIndexPath *)indexPath {
    return self.imageStrArray[indexPath.section][indexPath.row];
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(id)contextInfo {
    NSLog(@"保存成功");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
