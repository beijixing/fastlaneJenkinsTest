//
//  GetPicUtils.m
//  OrderManager
//
//  Created by fosung_mac01 on 15/7/10.
//  Copyright (c) 2015年 fosung. All rights reserved.
//

#import "GetPicUtils.h"

@interface GetPicUtils()
@end

@implementation GetPicUtils



- (void)addActionSheet:(NSString *)title{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:title
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"相机", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.viewConroller.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //判断是否可以打开相机，模拟器此功能无法使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
//                    picker.allowsEditing = YES;  //是否可编辑
                    //摄像头
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    
                    [self.viewConroller presentViewController:picker animated:YES completion:nil];
                
                
            }else{
                //如果没有提示用户
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
                [alert show];
            }
            break;
        }
        case 1:{
            AssetPickerController *picker = [[AssetPickerController alloc] init];
            [picker setAssetsFilter:[ALAssetsFilter allPhotos]];                                                           /// 指定显示种类
            [picker setMaximumNumberOfSelection:1];                                                                        /// 多选个数
            [picker setShowEmptyGroups:NO];                                                                                /// 显示空图片组
            [picker setDelegate:self];                                                                                     /// 指定代理
            [self.viewConroller presentViewController:picker animated:YES completion:nil];
            
            break;
        }
        case 2:
            [actionSheet didMoveToSuperview];
            break;
        default:
            break;
    }
}

- (void)assetPickerController:(AssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets {
    if (assets.count > 0) {
        CGImageRef cgimage = [assets[0] defaultRepresentation].fullScreenImage;     /// ALAsset 数组
        UIImage* image = [UIImage imageWithCGImage:cgimage];
      
        [self cutImage:image withWidth:self.imageWidth withHeight:self.imageHeight];
        
    }
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self cutImage:image withWidth:self.imageWidth  withHeight:self.imageHeight];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(void)cutImage:(UIImage *)image withWidth:(float)width withHeight:(float)height{
    MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
    imageCrop.delegate = self;
    imageCrop.ratioOfWidthAndHeight = width/height;
    imageCrop.image = image;
    [imageCrop showWithAnimation:YES];
    
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    [self.delegate resultImage:cropImage];

}

-(void)cancle{
    [self.viewConroller dismissViewControllerAnimated:YES completion:nil];
}
@end
