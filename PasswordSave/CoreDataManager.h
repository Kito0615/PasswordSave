//
//  CoreDataManager.h
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AccountInfo+CoreDataClass.h"


#define DEFAULT_MANAGER [CoreDataManager sharedManager]

@class AccountInfoBridge;
@interface CoreDataManager : NSObject

@property (readonly, nonatomic, strong) NSManagedObjectModel * managedObjectModel;
@property (readonly, nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (readonly, nonatomic, strong) NSPersistentStoreCoordinator * persistentStoreCoordinator;

+ (instancetype)sharedManager;
- (NSURL *)applicationDocumentsDirectory;

- (void)insertCoreData:(NSArray *)dataArray;
- (NSArray *)selectAll;
- (NSArray *)selectAccount:(NSString *)accountName site:(NSString *)siteName;
- (void)deleteData:(NSArray<AccountInfoBridge *> *)accounts;
- (void)updateData:(NSArray<AccountInfoBridge *> *)accounts;

@end
