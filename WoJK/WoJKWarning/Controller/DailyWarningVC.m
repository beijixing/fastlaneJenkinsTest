//
//  DailyWarningVC.m
//  WoJK
//
//  Created by Megatron on 16/4/21.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "DailyWarningVC.h"
#import "Macro.h"
#import "CircularImgeView.h"
#import "WJTextView.h"

@interface DailyWarningVC ()
{
    UIScrollView *_layerScrollview;
    float _scaleX;
}
@end

@implementation DailyWarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"日指标告警";
    _scaleX = MainScreenWidth/320.0;
    [self setupLeftBackButton];
    [self addLayerScrollView];
    [self addRightButton];
}

- (void)addLayerScrollView {
    _layerScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, MainScreenHeight - 64 - 49)];
    _layerScrollview.contentSize = CGSizeMake(self.view.frame.size.width, 568 - 64 - 49);
    _layerScrollview.backgroundColor = [UIColor colorWithRed:243/255.0 green:244/255.0 blue:246/255.0 alpha:1.0];
    [self.view addSubview:_layerScrollview];
    
    [self addSearchControls];
    [self addLeftDateBtnBgView];
    [self addLeftDateBtn];
    [self addRightDateBtn];
    [self addDateLabel];
    [self addIndexStateImage];
    [self addMobileIncomeDailyRelative];
    [self addProgressView];
    [self addColorBar];
    [self addBackupControl];
}

- (void)addRightButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.frame = CGRectMake(0, 0, 15, 25);
    [button addTarget:self action:@selector(sharedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"shared.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"shared.png"] forState:UIControlStateHighlighted];
    //    [button sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)sharedBtnClick:(UIButton *)button {
    
}


- (void)addSearchControls {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, 30)];
    bgView.center = CGPointMake(self.view.frame.size.width/2, 20);
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    searchImage.center = CGPointMake(15, 15);
    searchImage.image = [UIImage imageNamed:@"search"];
    [bgView addSubview: searchImage];
    
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 0, self.view.frame.size.width - 60, 30)];
    searchTextField.borderStyle = UITextBorderStyleNone;
    searchTextField.placeholder = @"搜索：关键词";
    [bgView addSubview:searchTextField];
}

#pragma mark - 左右按钮及日期

- (void)addLeftDateBtnBgView {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40*_scaleX)];
    bgView.center = CGPointMake(self.view.frame.size.width/2, 62.5*_scaleX);
    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];
}


- (void)addLeftDateBtn {
    UIButton *leftDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftDateBtn setImage:[UIImage imageNamed:@"report_left"] forState:UIControlStateNormal];
    leftDateBtn.frame = CGRectMake(20*_scaleX, 50*_scaleX, 25*_scaleX, 25*_scaleX);
    [leftDateBtn addTarget:self action:@selector(leftDateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_layerScrollview addSubview:leftDateBtn];

}

- (void)leftDateBtnEvent:(UIButton *)btn {
    
}

-(void)addRightDateBtn {
     UIButton *rightDateBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightDateBtn setImage:[UIImage imageNamed:@"report_right"] forState:UIControlStateNormal];
    rightDateBtn.frame = CGRectMake(MainScreenWidth - 45*_scaleX, 50*_scaleX, 25*_scaleX, 25*_scaleX);
    [rightDateBtn addTarget:self action:@selector(rightDateBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_layerScrollview addSubview:rightDateBtn];
}

- (void)rightDateBtnEvent:(UIButton *)btn {
    
}

-(void)addDateLabel {
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160*_scaleX, 30)];
    dateLabel.center = CGPointMake(MainScreenWidth/2, 62.5*_scaleX);
    dateLabel.text = @"今天 12月28日";
    //    self.dateLabel.text = [NSString formatNumberWithComma:@"234342343423"];
    dateLabel.font = [UIFont fontWithName:@"Arial" size:13];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.textColor = ColorWithRGB(56, 183, 240);
    [_layerScrollview addSubview:dateLabel];
}

#pragma mark 指标状态图
- (void)addIndexStateImage {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60 *_scaleX)];
    bgView.center = CGPointMake(self.view.frame.size.width/2, 114*_scaleX);
    bgView.backgroundColor = [UIColor whiteColor];
//    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"正常",@"轻微",@"严重",@"重大", nil];
    NSArray *backgroundColor = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor whiteColor], [UIColor whiteColor], [UIColor whiteColor], nil];
    NSArray *borderColor = [NSArray arrayWithObjects:[UIColor greenColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor redColor], nil];
    NSArray *titleColor = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor redColor], nil];
    
    
    CGFloat imageSpace = 140/5;
    CGFloat imageWidth = (MainScreenWidth-140)/4;
    for (int i = 0; i<4; i++) {
        CircularImgeView *circleImage = [[CircularImgeView alloc] initWithFrame:CGRectMake(i%4*(imageWidth+imageSpace)+imageSpace, (i/4)*(imageSpace+imageWidth)+10*_scaleX, imageWidth, imageWidth)];
        circleImage.title = titleArr[i];
        [circleImage setBackgroundColor:backgroundColor[i] andBorderColor:borderColor[i] andTitleColor:titleColor[i]];
        
        [bgView addSubview:circleImage];
    }
}

#pragma mark 移动业务计费收入日均环比
- (void)addMobileIncomeDailyRelative {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150*_scaleX, self.view.frame.size.width, 80 *_scaleX)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];
    
    UIImageView *dotImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20*_scaleX, 10*_scaleX, 10*_scaleX)];
    dotImageView.backgroundColor = [UIColor greenColor];
    dotImageView.layer.cornerRadius = 5*_scaleX;
    [bgView addSubview:dotImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 15*_scaleX, MainScreenWidth/4*3, 20*_scaleX)];
    titleLabel.text = @"移动业务计费收入日均环比";
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    [bgView addSubview:titleLabel];
    
    UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainScreenWidth-40, 16*_scaleX, 20*_scaleX, 20*_scaleX)];
    indicatorImageView.image = [UIImage imageNamed:@"report_right"];
    [bgView addSubview:indicatorImageView];
    
    UILabel *indexValueTitle = [[UILabel alloc] initWithFrame:CGRectMake(30, 40*_scaleX,  80*_scaleX, 20*_scaleX)];
    indexValueTitle.text = @"指标值";
    indexValueTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
    [bgView addSubview:indexValueTitle];
    
    UILabel *indexValue = [[UILabel alloc] initWithFrame:CGRectMake(30, 55*_scaleX,  80*_scaleX, 20*_scaleX)];
    indexValue.text = @"3.12%";
    indexValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [bgView addSubview:indexValue];
    
    
    UILabel *normaleValueTitle = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2, 40*_scaleX, 80*_scaleX, 20*_scaleX)];
    normaleValueTitle.text = @"正常范围";
    normaleValueTitle.font = [UIFont fontWithName:@"Helvetica" size:12];
    [bgView addSubview:normaleValueTitle];
    
    UILabel *normaleValue = [[UILabel alloc] initWithFrame:CGRectMake(MainScreenWidth/2, 55*_scaleX,  80*_scaleX, 20*_scaleX)];
    normaleValue.text = @">=-1.72%";
    normaleValue.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [bgView addSubview:normaleValue];
}



#pragma mark 进度条
- (void)addProgressView{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 231*_scaleX, self.view.frame.size.width, 40 *_scaleX)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];
    
    
    UISlider *sliderView = [[UISlider alloc] initWithFrame:CGRectMake(20, 20*_scaleX, MainScreenWidth-40, 5)];
    sliderView.value = 0.5;
    sliderView.maximumValue = 1.0;
    sliderView.minimumValue = 0.0;
    [bgView addSubview:sliderView];
    
}

#pragma mark 彩色条
-(void)addColorBar{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 272*_scaleX, self.view.frame.size.width, 50 *_scaleX)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];
    
    UIImageView *colorbarimage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth-20, 10)];
    colorbarimage.image = [UIImage imageNamed:@"colorBar"];
    [bgView addSubview:colorbarimage];
    
}


#pragma mark 添加备注
- (void)addBackupControl {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 323*_scaleX, self.view.frame.size.width, 160 *_scaleX)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.layer.cornerRadius = 5.0;
    [_layerScrollview addSubview:bgView];

    WJTextView *textView = [[WJTextView alloc] initWithFrame:CGRectMake(10, 10, MainScreenWidth-20, 120*_scaleX)];
    textView.placeHolder = @"请输入备注";
    textView.layer.borderColor = [UIColor grayColor].CGColor;
    textView.layer.borderWidth = 1.0f;
    [bgView addSubview:textView];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
