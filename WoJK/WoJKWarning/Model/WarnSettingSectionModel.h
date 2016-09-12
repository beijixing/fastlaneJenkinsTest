//
//  WarnSettingSectionModel.h
//  WoJK
//
//  Created by Megatron on 16/5/5.
//  Copyright © 2016年 zhilong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WarnSettingTargetModel.h"
@interface WarnSettingSectionModel : NSObject
@property (nonatomic, strong) NSArray<WarnSettingTargetModel *> *settingTargetArr;
@property (nonatomic, copy) NSString  *targetSpeciesID;
@property (nonatomic, copy) NSString *targetSpeciesName;

@end
