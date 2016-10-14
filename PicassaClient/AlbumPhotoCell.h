//
//  AlbumPhotoCell.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumPhotoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;

@property (weak, nonatomic) IBOutlet GDataEntryPhoto *photoEntry1;
@property (weak, nonatomic) IBOutlet GDataEntryPhoto *photoEntry2;
@property (weak, nonatomic) IBOutlet GDataEntryPhoto *photoEntry3;

@end
