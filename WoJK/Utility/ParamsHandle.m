//
//  ParamsHandle.m
//  HD100-Custom
//
//  Created by WenJie on 15/7/8.
//  Copyright (c) 2015年 fosung_mac02. All rights reserved.
//

#import "ParamsHandle.h"
#import "NSDateAdditions.h"
#import "Macro.h"
#import "AppConfig.h"
#import "NSStringAdditions.h"

@implementation ParamsHandle

+ (NSDictionary *)handleParamModels:(NSArray *)params
{
    // final字典 先加入系统参数和自定制参数
    NSMutableDictionary *final = [NSMutableDictionary dictionary];
    NSMutableArray *allParamModel = [NSMutableArray arrayWithArray:params];//自定制参数
    [allParamModel addObjectsFromArray:[ParamsHandle getSystemInfo]]; //系统参数
    for (ParamModel *model in allParamModel) {
        [final setObject:model.value forKey:model.key];
    }
    
    //筛选出需要签名的参数Model 前往签名
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"shouldSign=YES"];
    NSArray *aryToSign = [allParamModel filteredArrayUsingPredicate:predicate];
    NSMutableDictionary *dicToSign = [NSMutableDictionary dictionary];
    for (ParamModel *model in aryToSign) {
        [dicToSign setObject:model.value forKey:model.key];
    }
    
    //完成签名后将sign字段也加到final里 完成字典构建 返回！
    [final setObject:[ParamsHandle getSignWithDic:dicToSign] forKey:@"sign"];
    return final;
}

// 获取系统参数(这些是不变的)
+ (NSArray *)getSystemInfo
{
    NSString *timestamp = [NSDate getCurrentTime];
    NSString *format = @"json";
    NSString *appkey =  APPKEY;
    NSString *ver = @"1.0";
    NSString *sign_method = @"md5";
    NSMutableArray *ary = [
                    @[ParamModel(@"timestamp", timestamp, YES),
                      ParamModel(@"format", format, YES),
                      ParamModel(@"ver", ver, YES),
                      ParamModel(@"sign_method", sign_method, YES)
                     ]mutableCopy];
    if (appkey) {
        [ary addObject:ParamModel(@"appkey", appkey, YES)];
    }
    return ary;
}

// 按要求规则签名参数，生成sign字段
+ (NSString *)getSignWithDic:(NSDictionary *)dic
{
    NSArray *keyAry = [dic allKeys];
    NSArray *newKeyAry = [keyAry sortedArrayUsingSelector:@selector(compare:)];
    //拼接字符串
    NSString *appdeningString = nil;
    NSString *key = nil;
    for (int i=0; i<newKeyAry.count; i++) {
        key = newKeyAry[i];
        if (appdeningString==nil) {
            appdeningString = [NSString stringWithFormat:@"%@%@",key,[dic objectForKey:key]];
        }else{
            appdeningString = [NSString stringWithFormat:@"%@%@%@",appdeningString,key,[dic objectForKey:key]];
        }
    }
    if (APPCERT) {
        appdeningString = [NSString stringWithFormat:@"%@%@%@",APPCERT,appdeningString,APPCERT];
    }
    return [appdeningString md5String];
}
@end



@implementation ParamModel

+(ParamModel *)creatModelWithKey:(NSString *)key value:(id)value shouldSign:(BOOL)shouldSign
{
    ParamModel *model = [[ParamModel alloc]init];
    model.key = key;
    model.value = value;
    model.shouldSign = shouldSign;
    if (value==nil) {
        return nil;  //value值为nil时销毁自身，防止handle类相应处理出现crash
    }
    return model;
}

@end