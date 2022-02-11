//
//  VideoCell.h
//  gogo
//
//  Created by by.huang on 2017/11/24.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"
#import "BaseViewController.h"

@protocol VideoCellDelegate

-(void)OnPlayClick : (NSInteger)tag;

@end

@interface VideoCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier controller:(BaseViewController *)controller delegate : (id<VideoCellDelegate>)delegate;

-(void)setData : (NewsModel *)model;

+(NSString *)identify;

@end
