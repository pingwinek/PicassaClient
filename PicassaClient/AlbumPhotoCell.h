//
//  AlbumPhotoCell.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UILabel *titleOfAlbum;

@end
