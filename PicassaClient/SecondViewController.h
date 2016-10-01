//
//  SecondViewController.h
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonCamera;
@property (weak, nonatomic) IBOutlet UIButton *buttonPicture;

-(IBAction)takePictureFromCamera:(id)sender;
-(IBAction)takePictureFromGallery:(id)sender;

@end

