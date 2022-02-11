//
//  ColorUtil.h
//
//  Created by mark.zhang on 6/5/15.
//  Copyright (c) 2015 idreamsky. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

typedef NS_ENUM(NSInteger,ColorDirector){
    Left = 0,
    Top
};

@interface ColorUtil : NSObject

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

+ (void)setGradientColor : (UIView *)view startColor: (UIColor *)startColor endColor : (UIColor *)endColor director : (ColorDirector)director;

+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
