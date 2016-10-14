//
//  AlbumCell.m
//  PicassaClient
//
//  Created by mac on 30.09.2016.
//  Copyright © 2016 mac. All rights reserved.
//

#import "AlbumCell.h"

@implementation AlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAlbum:(GDataEntryPhotoAlbum *)anAlbum{
    _album = anAlbum;
    [_albumTitle setText:[_album.title stringValue]];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [_album.title stringValue]];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:pngFilePath]){
        UIImage *img = [UIImage imageWithContentsOfFile:pngFilePath];
        [_albumPhoto setImage:img];
    } else{
        [_albumPhoto setImage:[UIImage imageNamed:@"cameraPlaceholder"]];
    }
    [self getImage];
}

#pragma mark - Get Thumnail
-(void)getImage{
    
    //_service = [(AppDelegate *)[[UIApplication sharedApplication] delegate] service];
    
    NSURL *feedURL = [[_album feedLink] URL];
    if(feedURL){
        
        NSLog(@"Getting thumbail for %@", [_album.title stringValue]);
        [_service fetchFeedWithURL:feedURL
                          delegate:self
               didFinishSelector:@selector(photoTicket:finishedWithFeed:error:)];
    }
}
         
-(void)photoTicket:(GDataServiceTicket *)ticket finishedWithFeed:(GDataFeedPhotoAlbum *)feed error:(NSError *)error{
    if(!error){
        _photos = feed;
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"photosFetcher" object:nil];
        [self performSelector:@selector(getThumbnail) withObject:nil afterDelay:.5];
    }
}
         
-(void)getThumbnail{
    if(_album && [_album isKindOfClass:[GDataEntryPhotoAlbum class]]){
        NSArray *thumbnails = [[_album mediaGroup] mediaThumbnails];
        if([thumbnails count] > 0){
            NSString *imageURLString = [[thumbnails objectAtIndex:0] URLString];
            if(imageURLString){
                GTMHTTPFetcher *fetcher = [GTMHTTPFetcher fetcherWithURLString:imageURLString];
                [fetcher beginFetchWithDelegate:self didFinishSelector:@selector(imageFetcher:finishedWithData:error:)];
            }
        }
    }
}
         
-(void)imageFetcher:(GTMHTTPFetcher *)fetcher finishedWithData:(NSData *)data error:(NSError *)error{
    if(!error){
        NSLog(@"Got thumbnail for %@", [_album.title stringValue]);
        UIImage *img = [UIImage imageWithData:data];
        [_albumPhoto setImage:img];
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@.png", docDir, [_album.title stringValue]];
        NSData *data1 = [NSData dataWithData:UIImagePNGRepresentation(img)];
        [data1 writeToFile:pngFilePath atomically:YES];
    } else{
        NSLog(@"imageFetcher:%@ error:%@", fetcher, error);
    }
}

@end
