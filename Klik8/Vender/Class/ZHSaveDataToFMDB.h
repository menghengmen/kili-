#import <UIKit/UIKit.h>
#import "FMDatabase.h"

static NSString *DataBaseName=@"ZHJSONData.rdb";
static NSString *TableNameBLOB=@"ZHJSONBLOB";
static FMDatabase *dataBase;
@interface ZHSaveDataToFMDB : UIView

#pragma mark ----------保存数据
/**保存缓存数据:(字典,数组,JSon字符串)*/
+ (void)insertDataWithData:(id)data WithIdentity:(NSString *)identity;

#pragma mark ----------读取数据
+ (id)selectDataWithIdentity:(NSString *)identity;

#pragma mark ----------删除数据
+ (void)deleteDataWithIdentity:(NSString *)identity;

#pragma mark ----------是否存在
+ (BOOL)exsistDataWithIdentity:(NSString *)identity;

#pragma mark ----------清除所有缓存
+ (void)cleanAllData;

@end
