//
//  EditPicVC.m
//  PicassaClient
//
//  Created by mac on 01.10.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "EditPicVC.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface EditPicVC ()

@end

@implementation EditPicVC
{
    UIBarButtonItem *editBtn;
    UIBarButtonItem *doneBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init
    _filtersArray = [[NSMutableArray alloc] initWithCapacity:10];
    _currentCGImage = _img.CGImage;
    //set image
    _filterPreviewImage = [CIImage imageWithCGImage:self.img.CGImage];
    
    _context = [CIContext contextWithOptions:nil];
    [self loadFilters];
    
    //navigation bar
    UIBarButtonItem *actionbtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
    self.navigationItem.leftBarButtonItem = actionbtn;
    
    editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)];
    
    doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    self.navigationItem.rightBarButtonItem = editBtn;
    
    [_imgView setImage:_img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - Buttons Action
-(IBAction)edit:(id)sender{
    
    [UIView animateWithDuration:.5
                     animations:^{
                         CGRect frame = _imgView.frame;
                         frame.origin.y -= _viewFilterPreview.frame.size.height;
                         [_imgView setFrame:frame];
                     }];
    self.navigationItem.rightBarButtonItem = doneBtn;
}

-(IBAction)done:(id)sender{
    
    [UIView animateWithDuration:.5
                     animations:^{
                         CGRect frame = _imgView.frame;
                         frame.origin.y += _viewFilterPreview.frame.size.height;
                         [_imgView setFrame:frame];
                     }];
    self.navigationItem.rightBarButtonItem = editBtn;
}

#pragma mark View Helpers
-(void)loadFilters{
    
    dispatch_async(dispatch_get_current_queue(), ^{
        
        NSArray *list = [CIFilter filterNamesInCategories:[NSArray arrayWithObjects:kCICategoryBuiltIn, kCICategoryColorEffect, nil]];
        
        for(NSString *str in list)
        {
            CIFilter *filter = [CIFilter filterWithName:str keysAndValues:kCIInputImageKey, _filterPreviewImage, nil];
            [_filtersArray addObject:filter];
        }
        
        __block int offsetX = 10;
        __block int i = 0;
        
        //loop
        for(CIFilter *f in _filtersArray){
    
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(offsetX+5, 10, 60, 60)];
    
            // create a label to display the name
            UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, 8)];
            filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height + 10);
            
            //properties of filter name label
            if([f.name isEqualToString:@"CISepiaTone"])
            {
                filterNameLabel.text =  @"Sepia";
            }
            else if([f.name isEqualToString:@"CIColorMonochrome"])
            {
                filterNameLabel.text =  @"Monochrome";
            }
            else if([f.name isEqualToString:@"CIColorCube"])
            {
                filterNameLabel.text =  @"Cube";
            }
            else
            {
                filterNameLabel.text =  f.name;
            }
            
            filterNameLabel.backgroundColor = [UIColor clearColor];
            filterNameLabel.textColor = [UIColor whiteColor];
            filterNameLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:8];
            filterNameLabel.textAlignment = NSTextAlignmentCenter;
    
            //create view after filter
            CIImage *outputImage = [f outputImage];
    
            CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
    
            UIImage *smallImage =  [UIImage imageWithCGImage:cgimg];
    
            // create filter preview image views
            UIImageView *filterPreviewImageView = [[UIImageView alloc] initWithImage:smallImage];
    
            filterPreviewImageView.contentMode = UIViewContentModeScaleAspectFill;
            filterPreviewImageView.clipsToBounds = YES;
    
            [filterView setUserInteractionEnabled:YES];
    
            filterPreviewImageView.layer.cornerRadius = 4;
            filterPreviewImageView.opaque = NO;
            filterPreviewImageView.backgroundColor = [UIColor clearColor];
            filterPreviewImageView.layer.masksToBounds = YES;
            filterPreviewImageView.frame = CGRectMake(0, 0, 60, 60);
            filterView.tag = i;
    
            [filterView addSubview:filterPreviewImageView];
            [filterView addSubview:filterNameLabel];
    
            //create method that recognize filter
            UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(applyFilter:)];
            singleTapGestureRecognizer.numberOfTapsRequired = 1;
            [filterView addGestureRecognizer:singleTapGestureRecognizer];
            
            dispatch_async(dispatch_get_main_queue(), ^{[_viewFilterPreview addSubview:filterView];
            });
    
            offsetX += filterView.bounds.size.width + 10;
            i++;
        }
    });
}

-(IBAction)applyFilter:(id)sender {
    
    dispatch_async(dispatch_get_current_queue(), ^{
        int filterIndex = [(UITapGestureRecognizer *) sender view].tag;
        CIFilter *filter = [_filtersArray objectAtIndex:filterIndex];
        
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgimg = [_context createCGImage:outputImage fromRect:[outputImage extent]];
        
        _currentCGImage = cgimg;
        _filterPreviewImage = outputImage;
        
        UIImage *finalImage = [UIImage imageWithCGImage:cgimg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imgView setImage:finalImage];
        });
        CGImageRelease(cgimg);
    });
}

-(IBAction)action:(id)sender{
    
    NSString *message = @"Choose your action";
    NSString *cancelBtn = @"Cancel";
    NSString *exportImg = @"Export image";
    NSString *goBack = @"Quit";
    
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:message
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:exportImg
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self exportToGallery];
                             
                             [view dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:cancelBtn
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    [view addAction:ok];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

-(void)exportToGallery{
    ALAssetsLibrary *assetsLib = [ALAssetsLibrary new];
    [assetsLib writeImageToSavedPhotosAlbum:_currentCGImage
                                   metadata:[_filterPreviewImage properties]
                            completionBlock:^(NSURL *url, NSError *error){
                                UIAlertController *view = [UIAlertController
                                                             alertControllerWithTitle:@"Information"
                                                             message:@"Your image has benn transfered to local gallery"
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
                                
                                UIAlertAction* cancel = [UIAlertAction
                                                         actionWithTitle:@"OK"
                                                         style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action)
                                                         {
                                                             [view dismissViewControllerAnimated:YES completion:nil];
                                                             
                                                         }];
                                
                                [view addAction:cancel];
                                [self presentViewController:view animated:YES completion:nil];
                            }];
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
