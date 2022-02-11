//
//  AddressModel.h
//  gogo
//
//  Created by by.huang on 2017/11/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (assign, nonatomic) long address_id;
@property (copy, nonatomic) NSString *uid;
@property (copy, nonatomic) NSString *receiver;
@property (copy, nonatomic) NSString *tel;
@property (copy, nonatomic) NSString *location;
@property (copy, nonatomic) NSString *address_detail;



@end
