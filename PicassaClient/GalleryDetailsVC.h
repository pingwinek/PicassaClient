//
//  GalleryDetailsVC.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryDetailsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) NSString *albumTitle;

@end
