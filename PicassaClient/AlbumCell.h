//
//  AlbumCell.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *albumPhoto;
@property (weak, nonatomic) IBOutlet UILabel *albumTitle;

@property (nonatomic, strong) GDataEntryPhotoAlbum *album;
@property (nonatomic, strong) GDataFeedPhotoAlbum *photos;
@property (nonatomic, weak) GDataServiceGooglePhotos *service;

-(void)setAlbum:(GDataEntryPhotoAlbum *) anAlbum;

@end
