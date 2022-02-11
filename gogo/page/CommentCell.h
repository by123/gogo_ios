//
//  CommentCell.h
//  gogo
//
//  Created by by.huang on 2017/10/26.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentListModel.h"

@protocol CommentCellDelegate
@optional -(void)onCommentLikeClick : (long)comment_id;
@end

@interface CommentCell : UITableViewCell

@property (weak, nonatomic) id<CommentCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier delegate : (id<CommentCellDelegate>)delegate;

-(void)setData : (CommentListModel *)model;

+(NSString *)identify;

@end
