//
//  EditPicVC.h
//  PicassaClient
//
//  Created by mac on 01.10.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreImage/CoreImage.h>

@interface EditPicVC : UIViewController

@property(nonatomic, weak) IBOutlet UIImageView *imgView;
@property(weak,nonatomic) IBOutlet UIView *viewFilterPreview;

@property(nonatomic,strong) UIImage *img;
@property(nonatomic,strong) CIImage *filterPreviewImage;
@property(nonatomic,strong) NSMutableDictionary *filters;
@property(nonatomic,strong) CIContext *context;
@property(nonatomic,strong) NSMutableArray *filtersArray;

@end
