//
//  EditPicVC.m
//  PicassaClient
//
//  Created by mac on 01.10.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "EditPicVC.h"
#import "SecondViewController.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    /*
    //shadow
    CALayer *shadowLayer = [(AppDelegate *)[[UIApplication sharedApplication] delegate] createShadowWithFrame:CGRectMake(0, 0, 320, 5)];
    [self.view.layer addSublayer:shadowLayer];
     */
}

-(void)viewDidUnload{
    
    [self setViewFilterPreview:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [_imgView setImage:nil];
    _img = nil;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationIsPortrait);
}

-(void)resignActive:(NSNotification *)n{
    
    NSLog(@"APP RESIGN ACTIVE");
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
        
        //create sepia filter
        CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"
                                           keysAndValues:kCIInputImageKey, _filterPreviewImage,
                                 @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
        
        //create monochrome filter
        CIFilter *colorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome"
                                               keysAndValues:kCIInputImageKey, _filterPreviewImage,
                                     @"inputColor", [CIColor colorWithString:@"Red"],
                                     @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
        
        //create color cube
        CIFilter *cubeFilter = [CIFilter filterWithName:@"CIColorMatrix"
                                withInputParameters: @{
                                                       kCIInputImageKey: _filterPreviewImage,
                                                       @"inputRVector": [CIVector vectorWithX:-1 Y:0 Z:1],
                                                       @"inputGVector": [CIVector vectorWithX:0 Y:-1 Z:0],
                                                       @"inputBVector": [CIVector vectorWithX:0 Y:0 Z:-1],
                                                       @"inputBiasVector": [CIVector vectorWithX:1 Y:1 Z:1],
                                                       }];
        
        
        //create color invert
        CIFilter *invertFilter = [CIFilter filterWithName:@"CIColorInvert"
                                            keysAndValues: kCIInputImageKey, _filterPreviewImage,nil];
        
        //create dictionary obiect and add filters
        _filters = [[NSMutableDictionary alloc] init];
        [_filters setObject:sepiaFilter forKey:@"Sepia"];
        [_filters setObject:colorMonochrome forKey:@"Mono"];
        [_filters setObject:cubeFilter forKey:@"Matrix"];
        [_filters setObject:invertFilter forKey:@"Invert"];
        
        __block int offsetX = 10;
        __block int i = 0;
        
        //loop
        [_filters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop
            ){
    
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(offsetX+5, 10, 60, 60)];
    
            // create a label to display the name
            UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, 8)];
            filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height + 10);
            
            //properties of filter name label
            CIFilter *filter = (CIFilter *)obj;
            
            if([filter.name isEqualToString:@"CISepiaTone"])
            {
                filterNameLabel.text =  @"Sepia";
            }
            else if([filter.name isEqualToString:@"CIColorMonochrome"])
            {
                filterNameLabel.text =  @"Monochrome";
            }
            else if([filter.name isEqualToString:@"CIColorMatrix"])
            {
                filterNameLabel.text =  @"Matrix";
            }
            else if([filter.name isEqualToString:@"CIColorInvert"])
            {
                filterNameLabel.text =  @"Invert";
            }
            else
            {
                filterNameLabel.text =  filter.name;
            }
            
            filterNameLabel.backgroundColor = [UIColor clearColor];
            filterNameLabel.textColor = [UIColor whiteColor];
            filterNameLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:8];
            filterNameLabel.textAlignment = NSTextAlignmentCenter;
    
            //create view after filter
            CIImage *outputImage = [filter outputImage];
    
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
            
            CFRelease(cgimg);
        }];
    });
}

-(IBAction)applyFilter:(id)sender {
    
    dispatch_async(dispatch_get_current_queue(), ^{
        int filterIndex = [(UITapGestureRecognizer *) sender view].tag;
        CIFilter *filter = [_filters objectForKey:[[_filters allKeys]
                                                   objectAtIndex:filterIndex]];
        
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
                                                             SecondViewController *secViewCont = [[self storyboard] instantiateViewControllerWithIdentifier:@"SecViewCont"];
                                                             [self.navigationController pushViewController:secViewCont animated:YES];
                                                             
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
