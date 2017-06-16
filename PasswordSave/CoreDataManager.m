//
//  CoreDataManager.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "CoreDataManager.h"
#import "AccountInfoBridge.h"

#define ENTITY_NAME @"AccountInfo"
#define TABLE_NAME @"AccountInfo"

@implementation CoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (instancetype)sharedManager
{
    static CoreDataManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoreDataManager alloc] init];
    });
    return instance;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator * coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL * modelURL = [[NSBundle mainBundle] URLForResource:@"AccountInfo" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    NSURL * storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AccountInfo.sqlite"];
    NSError * error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
    }
    return _persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)insertCoreData:(NSArray *)dataArray
{
    NSManagedObjectContext * context = [self managedObjectContext];
    for (AccountInfoBridge * account in dataArray) {
        AccountInfo * info = [NSEntityDescription insertNewObjectForEntityForName:TABLE_NAME inManagedObjectContext:context];
        info.site_account = account.site_account;
        info.bound_phone = account.bound_phone;
        info.bound_email = account.bound_email;
        info.site_password = account.site_password;
        info.site_icon = account.site_icon;
        info.site_name = account.site_name;        
    }
    [self saveContext];
}
- (void)deleteData:(NSArray<AccountInfoBridge *> *)accounts
{
    
    for (AccountInfoBridge * bridge in accounts) {
        
        NSManagedObjectContext * context = [self managedObjectContext];
        NSFetchRequest * fetchRequest = [AccountInfo fetchRequest];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"site_account == %@ and site_name == %@", bridge.site_account, bridge.site_name];
        fetchRequest.predicate = predicate;
        NSError * error = nil;
        NSArray * arr = [context executeFetchRequest:fetchRequest error:&error];
        if (error == nil && arr.count) {
            [context deleteObject:arr.firstObject];
        }
        [self saveContext];
    }
}

- (NSArray *)selectAccount:(NSString *)accountName site:(NSString *)siteName
{
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [AccountInfo fetchRequest];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"site_account == %@ and site_name == %@", [accountName dataUsingEncoding:NSUTF8StringEncoding], siteName];
    fetchRequest.predicate = predicate;
    NSArray * arr = [context executeFetchRequest:fetchRequest error:nil];
    return arr;
}

- (NSArray *)selectAll
{
    NSManagedObjectContext * context = [self managedObjectContext];
    NSFetchRequest * fetchRequest = [AccountInfo fetchRequest];
    NSError * error = nil;
    NSArray * arr = [context executeFetchRequest:fetchRequest error:&error];
    return arr;
}

- (void)updateData:(NSArray<AccountInfoBridge *> *)accounts
{
    NSManagedObjectContext * context = [self managedObjectContext];
    AccountInfoBridge * account = accounts.firstObject;
    NSFetchRequest * fetchRequest = [AccountInfo fetchRequest];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"site_account == %@ and site_name == %@", account.site_account, account.site_name];
    fetchRequest.predicate = predicate;
    NSArray * arr = [context executeFetchRequest:fetchRequest error:nil];
    AccountInfo * info = arr.firstObject;
    info.bound_phone = account.bound_phone;
    info.bound_email = account.bound_email;
    info.site_password = account.site_password;
    
    [self saveContext];
}

- (void)saveContext
{
    NSManagedObjectContext * context = [self managedObjectContext];
    [context save:nil];
}

@end
