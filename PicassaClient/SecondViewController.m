//
//  SecondViewController.m
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "SecondViewController.h"
#import "EditPicVC.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)takePictureFromCamera:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentModalViewController:imagePicker animated:YES];
    }
    else{
        UIButton *tmp = (UIButton *)sender;
        [tmp setTitle:@"Camera not available" forState:UIControlStateNormal];
    }
}

-(IBAction)takePictureFromGallery:(id)sender{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    EditPicVC *editPicVC = [[self storyboard] instantiateViewControllerWithIdentifier:@"EditPictureVC"];
    [editPicVC setImg:image];
    
    [self dismissModalViewControllerAnimated:YES];
    
    [self.navigationController pushViewController:editPicVC animated:YES];
}

@end
