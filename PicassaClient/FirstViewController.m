//
//  FirstViewController.m
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "FirstViewController.h"
#import "AlbumCell.h"
#import "GalleryDetailsVC.h"
#import "AppDelegate.h"
#import "Constants.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _albums = [[NSMutableArray alloc] initWithCapacity:5];
    [_service setUserCredentialsWithUsername: CONST_USER password: CONST_PASSWORD];
    
    //HUD
    _HUD = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.delegate = self;
    _HUD.labelText = @"Loading..";
    _HUD.detailsLabelText = @"Getting data from Picassa";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellID"];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"albumDetailsSegue"]){
        
        GalleryDetailsVC *gallery = segue.destinationViewController;
        gallery.albumTitle = @"Our new album";
    }
}

@end
