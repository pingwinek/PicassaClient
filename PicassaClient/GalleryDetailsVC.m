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
    // Do any additional setup after loading the view.
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
    
    return 70.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumPhotoCellID"];
    cell.titleOfAlbum.text = self.albumTitle;
    
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
