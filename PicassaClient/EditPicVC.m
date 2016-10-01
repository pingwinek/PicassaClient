//
//  EditPicVC.m
//  PicassaClient
//
//  Created by mac on 01.10.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "EditPicVC.h"
#import <QuartzCore/QuartzCore.h>

@interface EditPicVC ()

@end

@implementation EditPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set image
    _filterPreviewImage = [CIImage imageWithCGImage:self.img.CGImage];
    [self loadFilters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        
        //create dictionary obiect and add filters
        _filters = [[NSMutableDictionary alloc] init];
        [_filters setObject:sepiaFilter forKey:@"Sepia"];
        [_filters setObject:colorMonochrome forKey:@"Mono"];
        
        __block int offsetX = 10;
        __block int i = 0;
        
        //loop
        [_filters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop
            ){
    
            UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(offsetX+5, 10, 60, 60)];
    
            // create a label to display the name
            UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, 8)];
    
            filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height + 10);
            
            //create filter object from dictionary object
            CIFilter *filter = (CIFilter *)obj;
    
            filterNameLabel.text =  filter.name;
            filterNameLabel.backgroundColor = [UIColor clearColor];
            filterNameLabel.textColor = [UIColor whiteColor];
            filterNameLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:10];
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
        
        UIImage *finalImage = [UIImage imageWithCGImage:cgimg];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imgView setImage:finalImage];
        });
        CGImageRelease(cgimg);
    });
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
