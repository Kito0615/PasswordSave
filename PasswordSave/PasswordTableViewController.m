//
//  PasswordTableViewController.m
//  PasswordSave
//
//  Created by AnarLong on 2017/5/18.
//  Copyright © 2017年 AnarL. All rights reserved.
//

#import "PasswordTableViewController.h"
#import "AddAccountViewController.h"
#import "AccountTableViewCell.h"
#import "CoreDataManager.h"
#import "Base64Encoder.h"
#import "DetailViewController.h"

#import "NSString+Localization.h"

#import <AdSupport/ASIdentifierManager.h>
#include <CommonCrypto/CommonDigest.h>

#define AD_UNIT_ID @"ca-app-pub-9800890094458111/3511196384"

@import GoogleMobileAds;

#define CELL_REUSE_IDENTIFIER @"cell"
#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size

@interface PasswordTableViewController () <GADBannerViewDelegate, UIViewControllerPreviewingDelegate>
{
    AddAccountViewController * aavc;
    NSMutableArray * dataSourceArr;
    
    NSIndexPath * selectedPath;
    CGRect sourceRect;
}
@property (nonatomic, strong) GADBannerView * bannerView;
@end

@implementation PasswordTableViewController
- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    if ([self.tabBarController.tabBar isHidden]) {
        [self.tabBarController.tabBar setHidden:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:self.view];
    }
    
    self.tableView.alwaysBounceVertical = YES;
    
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton addTarget:self action:@selector(addAccountInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = item;
    
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [settingButton setFrame:CGRectMake(0, 0, 32, 32)];
    [settingButton setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * settingItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = settingItem;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.leftBarButtonItem = ;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AccountTableViewCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CELL_REUSE_IDENTIFIER];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    [self.bannerView setFrame:CGRectMake(0, SCREEN_SIZE.height - 60 - 49 - kGADAdSizeBanner.size.height, kGADAdSizeBanner.size.width, kGADAdSizeBanner.size.height)];
    self.bannerView.adUnitID = AD_UNIT_ID;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    GADRequest * request = [GADRequest request];
#ifdef DEBUG
    request.testDevices = @[kGADSimulatorID, [self admobDeviceID]];
#endif
    [self.bannerView loadRequest:request];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.bannerView;
}

// https://stackoverflow.com/questions/24760150/how-to-get-a-hashed-device-id-for-testing-admob-on-ios
- (NSString *)admobDeviceID
{
    NSUUID * adid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    const char * cString = [adid.UUIDString UTF8String];
    unsigned char digest[16];
    CC_MD5(cString, strlen(cString), digest);
    NSMutableString * output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAccountInfo:(UIButton *)btn
{
    aavc = [[AddAccountViewController alloc] initWithNibName:@"AddAccountViewController" bundle:[NSBundle mainBundle]];
    aavc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:aavc animated:YES];
}

- (void)cleanAllData
{
    NSMutableArray * arrToRemove = [NSMutableArray array];
    for (AccountInfo * info in [DEFAULT_MANAGER selectAll]) {
        AccountInfoBridge * bridge = [[AccountInfoBridge alloc] initWithAccountInfo:info];
        [arrToRemove addObject:bridge];
    }
    
    [DEFAULT_MANAGER deleteData:arrToRemove];
}

- (void)createNewAccount
{
    [self addAccountInfo:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    dataSourceArr = [NSMutableArray arrayWithArray:[DEFAULT_MANAGER selectAll]];
    return [dataSourceArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CELL_REUSE_IDENTIFIER];
    if (cell == nil) {
        cell = [[AccountTableViewCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 60)];
    }
    AccountInfo * info = [dataSourceArr objectAtIndex:indexPath.row];
    cell.siteIconView.image = [UIImage imageNamed:info.site_icon];
//    [cell setIcon:[UIImage imageNamed:info.site_icon]];
    
    NSString * enName = info.site_name;
    if ([[NSString preferedLanguageCode] isEqualToString:@"zh-Hans-CN"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"site_icon" ofType:@"plist"];
        NSArray * infos = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary * dic in infos) {
            if ([[dic objectForKey:@"site"] isEqualToString:enName]) {
                cell.siteNameLabel.text = dic[@"site_cn"];
                break;
            }
        }
    } else {
        cell.siteNameLabel.text = enName;
    }
    cell.nameLabel.text = [Base64Encoder base64DecodeStringFromData:info.site_account];
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NSLocalizedString(@"delete", nil);
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AccountInfo * info = [dataSourceArr objectAtIndex:indexPath.row];
        AccountInfoBridge * bridge = [[AccountInfoBridge alloc] initWithAccountInfo:info];
        [DEFAULT_MANAGER deleteData:@[bridge]];
        [dataSourceArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:NSStringFromClass([DetailViewController class]) bundle:nil];
    detailViewController.info = [dataSourceArr objectAtIndex:indexPath.row];
    NSString * enName = [(AccountInfoBridge *)[dataSourceArr objectAtIndex:indexPath.row] site_name];
    if ([[NSString preferedLanguageCode] isEqualToString:@"zh-Hans-CN"]) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"site_icon" ofType:@"plist"];
        NSArray * infos = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary * dic in infos) {
            if ([[dic objectForKey:@"site"] isEqualToString:enName]) {
                detailViewController.title = dic[@"site_cn"];
                break;
            }
        }
    } else {
        detailViewController.title = enName;
    }
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -Private methods
- (BOOL)getShouldShowRectAdnIndexPathWithLocation:(CGPoint)location
{
    CGPoint tableLocation = [self.view convertPoint:location toView:self.tableView];
    selectedPath = [self.tableView indexPathForRowAtPoint:tableLocation];
    sourceRect = CGRectMake(0, selectedPath.row * 60, SCREEN_SIZE.height, 60);
    return selectedPath.row >= dataSourceArr.count + 10 ? NO : YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -GADBannerViewDelegate
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView
{
    NSLog(@"------>Did received ad.");
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"----->Received ad error : %@", error.localizedDescription);
}

#pragma mark -UIViewControllerPreviewing
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    if (![self getShouldShowRectAdnIndexPathWithLocation:location]) {
        return nil;
    }
    previewingContext.sourceRect = sourceRect;
    DetailViewController * dvc = [[DetailViewController alloc] initWithNibName:NSStringFromClass([DetailViewController class]) bundle:nil];
    dvc.info = [dataSourceArr objectAtIndex:selectedPath.row];
    [dvc showPasswordDirectly];
    return dvc;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self tableView:self.tableView didSelectRowAtIndexPath:selectedPath];
}

#pragma mark -Setting Action
- (void)settingAction:(UIButton *)sender
{
    SettingsViewController * svc = [[SettingsViewController alloc] initWithNibName:NSStringFromClass([SettingsViewController class]) bundle:nil];
    [self.tabBarController.tabBar setHidden:YES];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:svc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
@end
