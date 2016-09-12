//
//  CoreNewFeatureVC.m
//  CoreNewFeatureVC
//
//  Created by 冯成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CoreNewFeatureVC.h"
#import "NewFeatureScrollView.h"
#import "NewFeatureImageV.h"
#import "CoreArchive.h"


NSString *const NewFeatureVersionKey = @"NewFeatureVersionKey";

@interface CoreNewFeatureVC ()


/** 模型数组 */
@property (nonatomic,strong) NSArray *images;

/** scrollView */
@property (nonatomic,weak) NewFeatureScrollView *scrollView;

@property (nonatomic,copy) void(^enterBlock)();

@end

@implementation CoreNewFeatureVC

/*
 *  初始化
 */
+(instancetype)newFeatureVCWithModels:(NSArray *)models enterBlock:(void(^)())enterBlock{
    
    CoreNewFeatureVC *newFeatureVC = [[CoreNewFeatureVC alloc] init];
    
    newFeatureVC.images = models;
    
    //记录block
    newFeatureVC.enterBlock =enterBlock;
    
    return newFeatureVC;
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    //控制器准备
    [self vcPrepare];
    
    //显示了版本新特性，保存版本号
}


/*
 *  控制器准备
 */
-(void)vcPrepare{
    
    //添加scrollView
    NewFeatureScrollView *scrollView = [[NewFeatureScrollView alloc] init];
    
    _scrollView = scrollView;

    //添加
    [self.view addSubview:scrollView];
    
    //添加约束
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //添加图片
    [self imageViewsPrepare];
}




/*
 *  添加图片
 */
-(void)imageViewsPrepare{
    
    [self.images enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL *stop) {
        
        NewFeatureImageV *imageV = [[NewFeatureImageV alloc] init];
        
        //设置图片
        imageV.image = image;
        
        //记录tag
        imageV.tag = idx;
        
        if(idx == self.images.count -1) {
            
            //开启交互
            imageV.userInteractionEnabled = YES;
            
            //添加手势
            [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)]];
        }
        
        [_scrollView addSubview:imageV];
    }];
}



-(void)gestureAction:(UITapGestureRecognizer *)tap{
    
    UIView *tapView = tap.view;
    
    //禁用
    tapView.userInteractionEnabled = NO;
    
    if(UIGestureRecognizerStateEnded == tap.state) [self dismiss];
}

-(void)dismiss{
    
    if(self.enterBlock != nil) _enterBlock();
}

/*
 *  是否应该显示版本新特性页面
 */
+(BOOL)canShowNewFeature:(NSString *)info{
    
    //读取本地信息
    NSString *versionLocal = [CoreArchive strForKey:NewFeatureVersionKey];
    
    if(versionLocal!=nil){//说明有本地版本记录，且和当前系统版本一致
        
        return NO;
        
    }else{//无本地版本记录或本地版本记录与当前系统版本不一致
        
        //保存
        [CoreArchive setStr:info key:NewFeatureVersionKey];
        
        return YES;
    }
}

@end
