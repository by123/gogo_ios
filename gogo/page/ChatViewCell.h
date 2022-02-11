//
//  ChatViewCell.h
//  gogo
//
//  Created by by.huang on 2018/3/25.
//  Copyright © 2018年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTextModel.h"

@interface ChatViewCell : UITableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
   
-(void)updateData:(MessageTextModel *)model;

+(NSString *)identify;
    
@end
