//
//  MessageDetail.m
//  WoJK
//
//  Created by Megatron on 16/5/10.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "MessageDetail.h"
#import "RequestService.h"
#import "GeneralDataModel.h"
#import "WJHUD.h"
#import "Macro.h"

@interface MessageDetail ()

@end

@implementation MessageDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公告详情";
    [self setupLeftBackButton];
    
    [self setSystemMessage];
    [self setMessageReadStatus];
    
    if (AboveiOS7) {
        self.navigationController.navigationBar.barTintColor = MAIN_COLOR;
    }else{
        self.navigationController.navigationBar.tintColor = MAIN_COLOR;
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}

- (void)setSystemMessage {
    self.contentTextView.text = self.messageModel.content;
    if (self.messageModel.sendTime.length > 16){
        //self.sendTimeLB.text = [self.messageModel.sendTime substringToIndex:16];
        NSString *showText = [NSString stringWithFormat:@"%@ %@",self.messageModel.noticeTypeName, [self.messageModel.sendTime substringToIndex:16]];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:showText];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(self.messageModel.noticeTypeName.length+1, 16)];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(self.messageModel.noticeTypeName.length+1, 16)];
        self.titleLB.attributedText = attributedStr;
    }else {
        //self.sendTimeLB.text = @"";
        self.titleLB.text = self.messageModel.noticeTypeName;
    }
}

- (void)setMessageReadStatus {
    [WJHUD showOnView:self.view];
    [RequestService setSystemNoticeReadStatusWithId:self.messageModel.contentId andResult:^(BOOL success, id object) {
        [WJHUD hideFromView:self.view];
        if (success) {
            GeneralDataModel *dataModel = object;
            if ([dataModel.code isEqualToString:@"success"]) {
                self.messageModel.readStatus = 1;
            }
        }else {
            DLog(@"error=%@", object);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
