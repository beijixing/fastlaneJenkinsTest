//
//  GetPicUtils.h
//  OrderManager
//
//  Created by fosung_mac01 on 15/7/10.
//  Copyright (c) 2015年 fosung. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AssetPickerController.h"
#import "MLImageCrop.h"

@protocol GetPicUtilsDelegate <NSObject>

- (void)resultImage:(UIImage *)image;

@end
@interface GetPicUtils : NSObject<AssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MLImageCropDelegate,UIActionSheetDelegate>

@property  (weak ,nonatomic) UIViewController *viewConroller;
@property  (nonatomic) float imageHeight;
@property  (nonatomic) float imageWidth;
- (void)addActionSheet:(NSString *)title;
@property  (assign ,nonatomic) id<GetPicUtilsDelegate> delegate;
@end
