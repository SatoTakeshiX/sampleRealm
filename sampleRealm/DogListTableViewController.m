//
//  DogListTableViewController.m
//  sampleRealm
//
//  Created by satoutakeshi on 2015/07/28.
//  Copyright (c) 2015年 satoutakeshi. All rights reserved.
//

#import "DogListTableViewController.h"
#import <Realm/Realm.h>
#import "Dog.h"
#import "Owner.h"
@interface DogListTableViewController ()

@property NSMutableArray *dogsArray;

@end

@implementation DogListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (self.dogsArray.count == 0) {
        self.dogsArray = [[NSArray array] mutableCopy];
    }
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //犬をビューに見せびらかす
    [self _displayDogs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.dogsArray = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.dogsArray.count;
}

#pragma mark - UITavleViewデリゲートメソッド

//セルの生成
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self getTableCell:tableView cellIdentifier:@"DogCell"];
    
    Dog *dog = self.dogsArray[indexPath.row];
    cell.textLabel.text = dog.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"年齢は%ld歳", dog.age];
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - DB

-(void)_selectDBForDogs
{
    // Query the default Realm
    
    
    RLMResults *dogs = [Dog allObjects];
    
    for (Dog *dog in dogs) {
        
        Owner *owner = dog.owner;
        
        //自分の飼い主だけ取得する
        if ([owner.ID isEqualToString:self.ownerID]) {
             [self.dogsArray addObject:dog];
        }
        
    }
    
}

-(void)_displayDogs
{
    [self _selectDBForDogs];
    
    [self.tableView reloadData];
}


@end
