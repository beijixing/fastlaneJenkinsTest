

#import <Foundation/Foundation.h>

/*!
 *  宏定义 生成ParamModel对象
 *
 *  @param k key值
 *  @param v valud值
 *  @param s shouldSign值
 *
 *  @return ParamModel对象
 */
#define ParamModel(k,v,s)[ParamModel creatModelWithKey:k value:v shouldSign:s]


/*!
 *  参数Model
 */
@interface ParamModel : NSObject
@property (strong, nonatomic) id value;
@property (strong, nonatomic) NSString *key;
@property (assign, nonatomic) BOOL shouldSign;
+ (ParamModel *)creatModelWithKey:(NSString *)key value:(id)value shouldSign:(BOOL)shouldSign;
@end

/*!
 *  参数处理类(加密,拼接系统参数)
 */
@interface ParamsHandle : NSObject
+ (NSDictionary *)handleParamModels:(NSArray *)params;
+ (NSString *)getSignWithDic:(NSDictionary *)dic;
@end
