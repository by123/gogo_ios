//
//  ImageBuuton.m
//  gogo
//
//  Created by by.huang on 2017/12/16.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ImageBuuton.h"
@implementation ImageBuuton{
    int mDirect;
}

-(instancetype)initWithDirect : (int)direct{
    if(self == [super init]){
        mDirect = direct;
    }
    return self;
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat titleX;
    if(mDirect == Direct_Left){
        titleX = 10;
    }else{
        titleX = contentRect.size.width - 10 - 20;
    }
    CGFloat titleY = (contentRect.size.height - 20)/2;
    CGFloat titleW = 20;
    CGFloat titleH = 20;
    return CGRectMake(titleX, titleY, titleW, titleH);
}


//-(CGRect)titleRectForContentRect:(CGRect)contentRect{
//    CGFloat titleX;
//    if(mDirect == Direct_Left){
//        titleX = 10 + 20 ;
//    }else{
//        titleX = contentRect.size.width - 10 - 20 - 80;
//    }
//    CGFloat titleY = 0;
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleH = contentRect.size.height;
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}

@end
