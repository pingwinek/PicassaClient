//
//  GalleryDetailsVCViewController.m
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "GalleryDetailsVC.h"
#import "AlbumPhotoCell.h"

@interface GalleryDetailsVC ()

@end

@implementation GalleryDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //HUD
    _HUD = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview:_HUD];
    _HUD.dimBackground = YES;
    _HUD.delegate = self;
    _HUD.labelText = @"Loading..";
    _HUD.detailsLabelText = @"Getting data from Picasa";
    
    [_HUD show:YES];
    
    //notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photosFetched) name:@"photosFetched" object:nil];
    
    //reload table
    //[_tablePictures reloadData];
}

-(void)viewDidUnload{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View Helpers
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_HUD removeFromSuperview];
}

-(void)photosFetched{
    [_HUD hide:YES];
    [_tablePictures reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumPhotoCellID"];
    
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

@end
