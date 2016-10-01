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

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
