//
//  EditPicVC.m
//  PicassaClient
//
//  Created by mac on 01.10.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "EditPicVC.h"

@interface EditPicVC ()

@end

@implementation EditPicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.imgView setImage: self.img];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
