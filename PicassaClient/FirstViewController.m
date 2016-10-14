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
    _HUD.detailsLabelText = @"Getting data from Picasa";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSURL *feedURL = [GDataServiceGooglePhotos photoFeedURLForUserID:CONST_USER
                                                             albumID:nil
                                                           albumName:nil
                                                             photoID:nil
                                                                kind:nil
                                                              access:nil];
    
    [_service fetchFeedWithURL:feedURL
             delegate:self
             didFinishSelector:@selector(albumListFetchTicket:finishedWithFeed:error:)];
    
    [_HUD show:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - View Helper
-(void)hudWasHidden:(MBProgressHUD *)hud{
    [_HUD removeFromSuperview];
}

#pragma mark - GData Service
-(void)albumListFetchTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedPhotoUser *)feed error:(NSError *)error{
    NSLog(@"album fetched");
    if(!error){
        NSLog(@"OK");
        _albums = [NSMutableArray arrayWithArray:[feed entries]];
        NSLog(@"%d albums", [_albums count]);
        _albums = [NSMutableArray arrayWithArray:[_albums sortedArrayUsingComparator:^(id a, id b){
            GDataEntryPhotoAlbum *obj1 = (GDataEntryPhotoAlbum *)a;
            GDataEntryPhotoAlbum *obj2 = (GDataEntryPhotoAlbum *)b;
            NSString *first = [obj1.title stringValue];
            NSString *second = [obj2.title stringValue];
            return [first compare:second];
        }]];
        [_albumTableView reloadData];
    }
    [_HUD hide:YES];
}

-(void)deselectCell:(UITableViewCell *)cell{
    [cell setSelected:NO];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCellID"];
    if (cell == nil) {
        cell = [[AlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"albumCellID"];
    }
    
    [cell setAlbum:[_albums objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    AlbumCell *cell = (AlbumCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:cell.album, @"album", cell.photos, @"photos", nil];
    [self performSegueWithIdentifier:@"albumDetailsSegue" sender:dict];
    [self performSelector:@selector(deselectCell:) withObject:[tableView cellForRowAtIndexPath:indexPath] afterDelay:.5];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"albumDetailsSegue"]){
        
        GalleryDetailsVC *gallery = segue.destinationViewController;
        
        GDataEntryPhotoAlbum *album = [(NSDictionary *)sender objectForKey:@"album"];
        GDataFeedPhotoAlbum *photos = [(NSDictionary *)sender objectForKey:@"photos"];
        [gallery setAlbum:album];
        [gallery setPhotoAlbumFeed:photos];
    }
}

@end
