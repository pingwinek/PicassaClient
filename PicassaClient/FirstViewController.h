//
//  FirstViewController.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface FirstViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, weak) GDataServiceGooglePhotos *service;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSMutableArray *albums;

@end

