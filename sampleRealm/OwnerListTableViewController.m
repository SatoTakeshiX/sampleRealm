//
//  OwnerListTableViewController.m
//  sampleRealm
//
//  Created by satoutakeshi on 2015/07/28.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "OwnerListTableViewController.h"
#import <Realm/Realm.h>
#import "Owner.h"
#import "Dog.h"
#import "DogListTableViewController.h"
@interface OwnerListTableViewController ()
@property NSMutableArray *ownersArry;
@property NSString *selectOwnerID; //選択した飼い主のID
- (IBAction)addOwner:(UIBarButtonItem *)sender;
@end

@implementation OwnerListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (self.ownersArry.count == 0) {
        self.ownersArry = [[NSArray array] mutableCopy];
    }
    
    //飼い主データを投入
    [self _createOwnerIfNotExist];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //飼い主を一覧で表示
    [self _displayOwners];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    
    //データソースを削除
    self.ownersArry = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.ownersArry.count;
}

#pragma mark - UITavleViewデリゲートメソッド

//セルの生成
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self getTableCell:tableView cellIdentifier:@"OwnerCell"];
    
    Owner *owner = self.ownersArry[indexPath.row];
    cell.textLabel.text = owner.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"年齢は%ld歳", owner.age];
    
    return cell;
}

//セル生成メソッド
-(UITableViewCell*)getTableCell:(UITableView *)tableview cellIdentifier:(NSString *)cellIdentifier
{
    UITableViewCell *cell;
    NSString *cellID = cellIdentifier;
    
    cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //犬を飼い始める
    [self _insertDBForDogsWithIndexPath:indexPath];
    
    //犬一覧画面へ遷移
    [self performSegueWithIdentifier:@"detail" sender:nil];
    
}


#pragma mark - DB

-(void)_createOwnerIfNotExist
{
    //全ての飼い主を取得
    RLMResults *owners = [Owner allObjects];
    
    //データがあれば抜ける
    if (owners.count) {
        return;
    }
    
    //データがないので飼い主を作る
    Owner *owner = [[Owner alloc] init];
    owner.name = @"Mike";
    owner.age   =   28;
    owner.ID    =   [[NSUUID UUID] UUIDString];
    
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    [Owner createOrUpdateInRealm:realm withValue:owner];
    [realm commitWriteTransaction];
    
}

-(void)_selectAllOwners
{
    // Query the default Realm
    RLMResults *owners = [Owner allObjects]; // retrieves all Dogs from the default Realm
    
    for (Owner *owner in owners) {
        [self.ownersArry addObject:owner];
        NSLog(@"Owner's name : %@", owner.name);
    }

}

-(void)_displayOwners
{
    [self _selectAllOwners];
    
    [self.tableView reloadData];
}

-(void)_insertDBForDogsWithIndexPath:(NSIndexPath *)indexPath
{
    //名前と年齢をランダムにするための数字を作る
    NSInteger randam = arc4random() % 10 + 1;
    
    //犬を作成
    Dog *myDog = [[Dog alloc] init];
    myDog.name = [NSString stringWithFormat:@"Rex%ld", randam];
    myDog.age = randam;
    myDog.ID = [[NSUUID UUID] UUIDString];
    
    //全ての飼い主を取得
    RLMResults *owners = [Owner allObjects];
    
    //飼い主を特定
    Owner *owner = owners[indexPath.row];
    //犬の飼い主を指定
    myDog.owner = owner;
    
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    [Dog createOrUpdateInRealm:realm withValue:myDog];

    if ([Dog objectsWhere:@"ID = %@",myDog.ID].count==0) {
        //存在していないなら追加・更新してownerに追加する
        [realm addOrUpdateObject:myDog];
        [owner.dogs addObject:myDog];
    }else{
        //存在しているなら更新するだけ
        [realm addOrUpdateObject:myDog];
    }
    
    [realm commitWriteTransaction];
    
    self.selectOwnerID = owner.ID;

}
- (IBAction)addOwner:(UIBarButtonItem *)sender {
    
    // Get the default Realm
    RLMRealm *realm = [RLMRealm defaultRealm];
    
    // Add to Realm with transaction
    [realm beginWriteTransaction];
    
    //飼い主を作る
    Owner *owner = [[Owner alloc] init];
    owner.name = [NSString stringWithFormat:@"Mike:%ld", self.ownersArry.count];
    owner.age   =   28 + (self.ownersArry.count);
    owner.ID    =   [[NSUUID UUID] UUIDString];

    [Owner createOrUpdateInRealm:realm withValue:owner];
    [realm commitWriteTransaction];
    
    //データソースの更新
    [self.ownersArry addObject:owner];

    //tableviewの更新
    [self.tableView reloadData];
    

}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.

    
    if ([segue.identifier isEqualToString:@"detail"]) {
        DogListTableViewController *dogListVC = segue.destinationViewController;
        dogListVC.ownerID = self.selectOwnerID;
    }
}

@end
