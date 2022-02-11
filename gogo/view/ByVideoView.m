//
//  ByVideoView.m
//  gogo
//
//  Created by by.huang on 2017/12/3.
//  Copyright © 2017年 by.huang. All rights reserved.
//

#import "ByVideoView.h"
#import <AVKit/AVKit.h>
#import "PlayButton.h"

@interface ByVideoView()

@property (strong, nonatomic) AVPlayerLayer *playLayer;
@property (strong, nonatomic) AVPlayer *player;
@property (copy, nonatomic) NSString *urlStr;
@property (strong, nonatomic) UIImageView *preImageView;
@property (strong, nonatomic) PlayButton *playBtn;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation ByVideoView

-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self initView :frame];
    }
    return self;
}

-(void)initView : (CGRect)frame{
    
    self.frame = frame;
    _preImageView = [[UIImageView alloc]init];
    _preImageView.frame =CGRectMake(0, 0, ScreenWidth, frame.size.height);
    _preImageView.contentMode =UIViewContentModeScaleToFill;
    _preImageView.hidden = YES;
    [self addSubview:_preImageView];
    
    
    UIImage *image = [UIImage imageNamed:@"ic_play"];
    _playBtn = [[PlayButton alloc]initWithImage:CGRectMake(0, 0, frame.size.width, frame.size.height) image:image];
    [_playBtn addTarget:self action:@selector(doPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playBtn];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pause)];
    [self addGestureRecognizer:recognizer];
}

-(void)setPreImageUrl : (NSString *)url{
    [_preImageView sd_setImageWithURL:[NSURL URLWithString:url]];
}


-(void)setUrl:(NSString *)url{
    self.urlStr = url;
}

-(void)setButtonTag : (NSInteger)tag{
    _playBtn.tag = tag;
}


//开始播放
-(void)doPlay : (UIButton *)button{
    if(_delegate){
        [_delegate OnPlayClick:button.tag];
    }
}


//播放
-(void)play{
    if(IS_NS_STRING_EMPTY(_urlStr)){
        return;
    }
    _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_urlStr]];
    _player = [AVPlayer playerWithPlayerItem:_playerItem];
    _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    _playLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playLayer.videoGravity  = AVLayerVideoGravityResizeAspectFill;
    // 监听status属性
    [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    // 监听loadedTimeRanges属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    // 设置player的item
    _playLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:_playLayer];
}


//暂停
-(void)pause{
    [_playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [_player pause];
    [_player setRate:0];
    [_playLayer removeFromSuperlayer];
    _player = nil;
    _playerItem = nil;
    _playLayer = nil;

    [self bringSubviewToFront:_preImageView];
    [self bringSubviewToFront:_playBtn];
    _playBtn.hidden = NO;
    _preImageView.hidden = NO;
}


//监听状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerItemStatus status =[change[@"new"]integerValue];//change为string类型
        switch (status) {
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频加载未知状态");
                break;
            case AVPlayerItemStatusReadyToPlay:
                _preImageView.hidden = YES;
                _playBtn.hidden = YES;
                [_player play];
                break;
            case AVPlayerItemStatusFailed:{
                [DialogHelper showWarnTips:@"视频加载失败,请重试"];
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //加载百分比
//        NSTimeInterval loadedTime = [self availableDurationWithplayerItem:_playerItem];
//        NSTimeInterval totalTime = CMTimeGetSeconds(_playerItem.duration);
        //播放百分比
        NSTimeInterval current = CMTimeGetSeconds(self.player.currentTime);
        NSTimeInterval total = CMTimeGetSeconds(self.player.currentItem.duration);
        float percent = current * 100 / total;
        NSLog(@"已播放百分比：%.2f",percent);
    }
}


// 获取缓冲进度
- (NSTimeInterval)availableDurationWithplayerItem:(AVPlayerItem *)playerItem {
    
    NSArray * loadedTimeRanges = [playerItem loadedTimeRanges];
    // 获取缓冲区域
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);
    NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);
    // 计算缓冲总进度
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

@end
