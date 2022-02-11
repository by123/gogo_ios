//
//  UploadImageUtil.h
//  gogo
//
//  Created by by.huang on 2017/11/15.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UploadImageDelegate <NSObject>

-(void)uploadSuccess : (NSString *)imageUrl;

-(void)uploadFail;

@end

@interface UploadImageUtil : NSObject

+(void)getUploadToken : (NSData *)imageData delegate : (id<UploadImageDelegate>)delegate;

@end
