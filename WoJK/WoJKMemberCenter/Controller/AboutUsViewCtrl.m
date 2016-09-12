//
//  AboutUsViewCtrl.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/21.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "AboutUsViewCtrl.h"
#import "Macro.h"
#import "RequestService.h"
#import "AboutUsDataModel.h"
#import "WJHUD.h"
#import "UIImageView+WebCache.h"

@interface AboutUsViewCtrl ()
{
    UIImageView *_bigQRCodeImage;
    UIView *_qrBgView;
}
@property (strong, nonatomic) IBOutlet UIImageView *qrCodeImageView;
@property (strong, nonatomic) IBOutlet UITextView *aboutUsContentTextView;
@property (strong, nonatomic) IBOutlet UILabel *way1Label;
@property (strong, nonatomic) IBOutlet UILabel *way2Label;

@end

@implementation AboutUsViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBackButton];
    self.navigationItem.title = @"关于我们";
    
    [self getAboutUsInfo];
    // Do any additional setup after loading the view.

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrCodeImageTapped:)];
    self.qrCodeImageView.userInteractionEnabled = YES;
    [self.qrCodeImageView addGestureRecognizer:tapGesture];
    
    
    _bigQRCodeImage = [[UIImageView alloc] init];
    _bigQRCodeImage.frame = self.qrCodeImageView.frame;
    _qrBgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _qrBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _qrBgView.hidden = YES;
    UITapGestureRecognizer *bgViewTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qrBgViewTapped:)];
    [_qrBgView addGestureRecognizer:bgViewTapGesture];
    [_qrBgView addSubview:_bigQRCodeImage];
    [self.view addSubview:_qrBgView];
    [self setDownloadWaysDesLB];
}

- (void)setDownloadWaysDesLB {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:@"1、微信 扫一扫 打开下载地址"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(5, 3)];
    self.way1Label.attributedText = attributedStr;
    
    attributedStr = [[NSMutableAttributedString alloc]initWithString:@"2、选择右上角在浏览器中打开"];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(7, 7)];
    self.way2Label.attributedText = attributedStr;

}


- (void)qrCodeImageTapped:(UITapGestureRecognizer *)gesture {
    _qrBgView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        _bigQRCodeImage.frame = CGRectMake(0, 0, MainScreenWidth/2, MainScreenWidth/2);
        _bigQRCodeImage.center = CGPointMake(MainScreenWidth/2, (MainScreenHeight-64)/2);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)qrBgViewTapped:(UITapGestureRecognizer *)gesture {
    
    [UIView animateWithDuration:0.2 animations:^{
        _bigQRCodeImage.frame = self.qrCodeImageView.frame;
    } completion:^(BOOL finished) {
         _qrBgView.hidden = YES;
    }];
}

- (void)getAboutUsInfo {
    [WJHUD showOnView:self.view];
    [RequestService queryAboutUsWithResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            AboutUsDataModel *dataModel = object;
            NSMutableString *desStr = [[NSMutableString alloc] initWithString:dataModel.appDesc];
            [desStr replaceOccurrencesOfString:@"&nbsp;" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, desStr.length)];
            [desStr appendString:@"\n\n"];
            [desStr appendString:dataModel.linkManDesc];
            [desStr appendString:@"\n\n"];
            [desStr appendString:dataModel.depDesc];
            self.aboutUsContentTextView.text = desStr;
            if (dataModel.ercodeUrl) {
                [self.qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.ercodeUrl] placeholderImage:[UIImage imageNamed:@"qrCode"]];
                [_bigQRCodeImage sd_setImageWithURL:[NSURL URLWithString:dataModel.ercodeUrl]];
            }
        }else {
            DLog(@"error = %@", object);
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
