//
//  SignView.m
//  gogo
//
//  Created by by.huang on 2017/12/9.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "SignView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "SoundUtil.h"
#import "RespondModel.h"
#import "OkAlertView.h"

@interface SignView()<CAAnimationDelegate>

//@property (strong, nonatomic) UILabel *signLabel;
@property (strong, nonatomic) UIImageView *coinImageView;
@property (assign, nonatomic) SystemSoundID soundID;
@property (strong, nonatomic) CAEmitterLayer * emitterLayer;//粒子动画

@end

@implementation SignView

-(instancetype)init{
    if(self == [super init]){
        [self initView];
    }
    return self;
}


-(void)initView{
    self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    
//    int width = ScreenWidth - [PUtil getActualWidth:200];
    int height = [PUtil getActualHeight:500];
//    UIView *contentView = [[UIView alloc]init];
//    contentView.backgroundColor = c06_backgroud;
//    contentView.frame = CGRectMake([PUtil getActualWidth:100], (ScreenHeight - height)/2, width, height);
//    contentView.layer.masksToBounds = YES;
//    contentView.layer.cornerRadius = 4;
//    [self addSubview:contentView];
//
//    UILabel *topLabel = [[UILabel alloc]init];
//    topLabel.text = @"点击竞猜币签到";
//    topLabel.textAlignment = NSTextAlignmentCenter;
//    topLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
//    topLabel.textColor = c08_text;
//    topLabel.backgroundColor = c01_blue;
//    topLabel.frame = CGRectMake(0, 0, width, [PUtil getActualHeight:100]);
//    [contentView addSubview:topLabel];
//
//    _signLabel = [[UILabel alloc]init];
//    _signLabel.text = @"已连续签到1天";
//    _signLabel.textAlignment = NSTextAlignmentCenter;
//    _signLabel.font = [UIFont systemFontOfSize:[PUtil getActualHeight:30]];
//    _signLabel.textColor = c08_text;
//    _signLabel.backgroundColor = c02_red;
//    _signLabel.frame = CGRectMake(0, [PUtil getActualHeight:400], width, [PUtil getActualHeight:100]);
//    [contentView addSubview:_signLabel];
//
//
    _coinImageView = [[UIImageView alloc]init];
    UIImage *coinImage = [UIImage imageNamed:@"ic_coin"];
    _coinImageView.userInteractionEnabled = YES;
//    _coinImageView.image = coinImage;
    _coinImageView.frame = CGRectMake((ScreenWidth - [PUtil getActualHeight:150])/2, (ScreenHeight - height)/2 + [PUtil getActualHeight:175], [PUtil getActualHeight:150], [PUtil getActualHeight:150]);
//    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSign)];
//    [_coinImageView addGestureRecognizer:recognizer];
    [self addSubview:_coinImageView];
    
    [self initMyEmitter];
    [self doSign];
}


-(void)doSign{
    [self startAnimation];
    [self playSound];
    [self doRequestSign];
}

-(void)doRequestSign{
    [ByNetUtil get:API_SIGN parameters:nil success:^(RespondModel *model) {
        if(model.code == 200){
            id data = model.data;
            id sign = [data objectForKey:@"sign_in"];
            int day = [[sign objectForKey:@"day"] intValue];
            NSArray *coins = [sign objectForKey:@"gift_coin"];
            if(!IS_NS_COLLECTION_EMPTY(coins)){
                long currentCoin = 0L;
                if([coins count] >= day){
                    currentCoin = [[coins objectAtIndex:day - 1] longValue];
                }else{
                    currentCoin = [[coins lastObject] longValue];
                }
                OkAlertView *okAlertView = [[OkAlertView alloc]initWithTitle:@"签到结果" content:[NSString stringWithFormat:@"今日签到成功，获得%ld竞猜币",currentCoin]];
                [self addSubview:okAlertView];

            }
            if(_delegate){
                [_delegate OnSignSuccess];
            }
        }

    } failure:^(NSError *error) {
        
    }];

}

- (void)startAnimation{
    CABasicAnimation * effectAnimation = [CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
    effectAnimation.fromValue = [NSNumber numberWithFloat:30];
    effectAnimation.toValue = [NSNumber numberWithFloat:0];
    effectAnimation.duration = 2.0f;
    effectAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    effectAnimation.delegate = self;
    [self.emitterLayer addAnimation:effectAnimation forKey:@"zanCount"];
}

//初始化粒子
-(void)initMyEmitter{
    //发射源
    CAEmitterLayer * emitter = [CAEmitterLayer layer];
    emitter.frame = CGRectMake(0, 0, CGRectGetWidth(_coinImageView.frame), CGRectGetHeight(_coinImageView.frame));
    [_coinImageView.layer addSublayer:self.emitterLayer = emitter];
    //发射源形状
    emitter.emitterShape = kCAEmitterLayerCircle;
    //发射模式
    emitter.emitterMode = kCAEmitterLayerOutline;
    //渲染模式
    //    emitter.renderMode = kCAEmitterLayerAdditive;
    //发射位置
    emitter.emitterPosition = CGPointMake(_coinImageView.frame.size.width/2.0, _coinImageView.frame.size.height/2.0);
    //发射源尺寸大小
    emitter.emitterSize = CGSizeMake(20, 20);
    
    // 从发射源射出的粒子
    
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    cell.name = @"zanShape";
    //粒子要展现的图片
    cell.contents = (__bridge id)[UIImage imageNamed:@"ic_coin_1"].CGImage;
    //    cell.contents = (__bridge id)[UIImage imageNamed:@"EffectImage"].CGImage;
    //            cell.contentsRect = CGRectMake(100, 100, 100, 100);
    //粒子透明度在生命周期内的改变速度
    cell.alphaSpeed = -0.5;
    //生命周期
    cell.lifetime = 3.0;
    //粒子产生系数(粒子的速度乘数因子)
    cell.birthRate = 0;
    //粒子速度
    cell.velocity = 300;
    //速度范围
    cell.velocityRange = 150;
    //周围发射角度
    cell.emissionRange = M_PI / 8;
    //发射的z轴方向的角度
    cell.emissionLatitude = -M_PI;
    //x-y平面的发射方向
    cell.emissionLongitude = -M_PI / 2;
    //粒子y方向的加速度分量
    cell.yAcceleration = 250;
    emitter.emitterCells = @[cell];
}

#pragma mark - 播放音效
-(void)playSound{
    self.soundID = [SoundUtil creatSoundIDWithSoundName:@"coin.mp3"];
    [SoundUtil playSoundWithSoundID:self.soundID];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if(flag){
        AudioServicesDisposeSystemSoundID(self.soundID);
        [self removeFromSuperview];
    }
}




@end
