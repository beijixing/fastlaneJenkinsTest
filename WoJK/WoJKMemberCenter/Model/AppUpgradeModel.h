//
//  AppUpgradeModel.h
//  WoJK
//
//  Created by Megatron on 16/4/19.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import "JSONModel.h"

@interface AppUpgradeModel : JSONModel
@property (strong, nonatomic) NSString *versionStatus;
@property (strong, nonatomic) NSString *downloadURL;
@property (strong, nonatomic) NSString *instruction;
@end
