//
//  AlbumPhotoCell.m
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "AlbumPhotoCell.h"

@implementation AlbumPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    [_btn1 setTag:1];
    [_btn2 setTag:2];
    [_btn3 setTag:3];
    
    [self getThumbnailForPhoto:_photoEntry1 forBtn:_btn1];
    
    if(!_photoEntry2){
        [_btn2 removeFromSuperview];
    } else{
        [self getThumbnailForPhoto:_photoEntry2 forBtn:_btn2];
    }
    if(!_photoEntry3){
        [_btn3 removeFromSuperview];
    } else{
        [self getThumbnailForPhoto:_photoEntry3 forBtn:_btn3];
    }
}

#pragma mark - Get Photo
-(void)getThumbnailForPhoto:(GDataEntryPhoto *)photoEntry forBtn:(UIButton *)btn{
        if(photoEntry && [photoEntry isKindOfClass:[GDataEntryPhoto class]]){
            NSArray *thumbnails = [[photoEntry mediaGroup] mediaThumbnails];
            if([thumbnails count] > 0){
                NSString *imageURLString = [[thumbnails objectAtIndex:0] URLString];
                if(imageURLString){
                    GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURL:imageURLString];
                    [fetcher setCommentWithFormat:@"%d", btn.tag];
                    [fetcher beginFetchWithDelegate:self didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
            }
        }
    }
}

-(void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error{
    if(!error){
        UIImage *img = [UIImage imageWithData:data];
        NSString *btnTag = fetcher.comment;
        if([btnTag isEqualToString:@"1"]){
            [_btn1 setImage:img forState:UIControlStateNormal];
        } else if([btnTag isEqualToString:@"2"]){
            [_btn2 setImage:img forState:UIControlStateNormal];
        }else if([btnTag isEqualToString:@"3"]){
            [_btn3 setImage:img forState:UIControlStateNormal];
        }
    }else{
        NSLog(@"imageFetcher:%@ error:%@", fetcher, error);
    }
}

@end
