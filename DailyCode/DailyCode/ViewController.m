//
//  ViewController.m
//  DailyCode
//
//  Created by DaBao on 16/8/2.
//  Copyright © 2016年 AISDDaBao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

/**
 *  定时任务GCD
 */
- (void)GCDTimer {

    // 执行一次(2.0秒后调用)
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        //执行事件
    });

    // 重复执行
    NSTimeInterval period = 1.0; //设置时间间隔 间隔1秒重复调用
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //在这里执行事件
    });
    dispatch_resume(_timer);
}


/**
 *  定时任务CADisplayLink
 */
- (void)CADisplayLinkTimer {
    //1. 创建方法
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(handleDisplayLink:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

    //2. 停止方法
    [displayLink invalidate];
    displayLink = nil;

//    当把CADisplayLink对象add到runloop中后，selector就能被周期性调用，类似于重复的NSTimer被启动了；执行invalidate操作时，CADisplayLink对象就会从runloop中移除，selector调用也随即停止，类似于NSTimer的invalidate方法。**
//    3. 特点：
//    屏幕刷新时调用：CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。所以通常情况下，按照iOS设备屏幕的刷新率60次/秒
//
//    延迟：iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。但如果调用的方法比较耗时，超过了屏幕刷新周期，就会导致跳过若干次回调调用机会。
//    如果CPU过于繁忙，无法保证屏幕60次/秒的刷新率，就会导致跳过若干次调用回调方法的机会，跳过次数取决CPU的忙碌程度。
//
//    使用场景：从原理上可以看出，CADisplayLink适合做界面的不停重绘，比如视频播放的时候需要不停地获取下一帧用于界面渲染。
//    4. 重要属性
//    frameInterval
//    NSInteger类型的值，用来设置间隔多少帧调用一次selector方法，默认值是1，即每帧都调用一次。
//    duration
//    readOnly的CFTimeInterval值，表示两次屏幕刷新之间的时间间隔。需要注意的是，该属性在target的selector被首次调用以后才会被赋值。selector的调用间隔时间计算方式是：调用间隔时间 = duration × frameInterval。
}

/**
 *  定时任务NSTimer
 */
- (void)NSTimerTimer {
//    1. 创建方法
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(action:) userInfo:nil repeats:NO];
//    TimerInterval : 执行之前等待的时间。比如设置成1.0，就代表1秒后执行方法
//    target : 需要执行方法的对象。
//    selector : 需要执行的方法
//    repeats : 是否需要循环
//    action :定时方法
//    2. 释放方法
    [timer invalidate];
    timer=nil;//最好置空,防止出错

//    注意 : 调用创建方法后，target对象的计数器会加1，直到执行完毕，自动减1。如果是循环执行的话，就必须手动关闭，否则可以不执行释放方法。
}

/**
 *  销毁任务
 */
-(void)dealloc {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
