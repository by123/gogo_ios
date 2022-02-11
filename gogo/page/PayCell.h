//
//  PayCell.h
//  gogo
//
//  Created by by.huang on 2017/10/29.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_CLASS_DEPRECATED_IOS(2_0, 9_0, "PayCell is Deprecated") __TVOS_PROHIBITED
@interface PayCell : UITableViewCell

-(void)setData : (NSString *)title hideline : (Boolean)hideline image:(NSString *)image;

-(void)setSelect : (Boolean)select;

+(NSString *)identify;

@end
