//
//  GalleryDetailsVC.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface GalleryDetailsVC : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property(nonatomic,strong) NSString *albumTitle;

@property (nonatomic, retain) GDataEntryPhotoAlbum *album;
@property (nonatomic, weak) GDataServiceGooglePhotos *service;
@property (nonatomic, strong) GDataFeedPhotoAlbum *photoAlbumFeed;
@property (nonatomic, strong) MBProgressHUD *HUD;

@property (nonatomic, weak) IBOutlet UITableView *tablePictures;

@end
