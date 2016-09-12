//
//  WJTextField.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/9.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "WJTextField.h"

@implementation WJTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setLeftWords:(NSString *)leftWords
{
    _leftWords = leftWords;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 14)];
    label.text = leftWords;
    label.font = [UIFont boldSystemFontOfSize:14];
    self.leftView = label;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)setLeftImage:(UIImage *)leftImage
{
    _leftImage = leftImage;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, self.bounds.size.height)];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/2-9, 14, 18)];
    imv.image = leftImage;
    [view addSubview:imv];
    self.leftView = view;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void)initialize
{
    UIImage *image = [UIImage imageNamed:@"input_normal"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    self.background = image;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(beginEdite) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endEdite) name:UITextFieldTextDidEndEditingNotification object:nil];
    [self setNeedsDisplay];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    
    [self initialize];
}

- (void)beginEdite
{
    if ([self isFirstResponder]) {
        UIImage *image = [UIImage imageNamed:@"input_focus"];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
        self.background = image ;
    }else
    {
        UIImage *image = [UIImage imageNamed:@"input_normal"];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
        self.background = image ;
    }
}
- (void)endEdite
{
    
    UIImage *image = [UIImage imageNamed:@"input_normal"];
    image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/2)];
    self.background = image ;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
