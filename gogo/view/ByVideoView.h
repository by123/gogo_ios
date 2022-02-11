//
//  ByVideoView.h
//  gogo
//
//  Created by by.huang on 2017/12/3.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ByVideoViewDelegate

-(void)OnPlayClick : (NSInteger)tag;

@end


@interface ByVideoView : UIView

@property (weak, nonatomic) id<ByVideoViewDelegate> delegate;

-(void)setPreImageUrl : (NSString *)url;
-(void)setUrl : (NSString *)url;
-(void)setButtonTag : (NSInteger)tag;
-(void)play;
-(void)pause;

@end
