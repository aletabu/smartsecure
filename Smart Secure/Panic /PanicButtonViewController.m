//
//  PanicButtonViewController.m
//  Smart Secure
//
//  Created by Constanza Areco on 11/07/13.
//  Copyright (c) 2013 CIDWAY Security. All rights reserved.
//

#import "PanicButtonViewController.h"
#import "ConfigurationData.h"
#import "MessagesScreenViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "KeyChainHelper.h"

#define ANIMATED_IMAGES_COUNT 38

int imageCounter;
double secondsPerImage;
BOOL alarmSent;

@interface PanicButtonViewController ()

@end

@implementation PanicButtonViewController
@synthesize panicTimer, timeOutTimer, panicGifImage, icon, netTitle, messagesScreenButton, panicScreenButton;

- (void) stopTimeOutTimer {
    if (timeOutTimer != nil) {
		[timeOutTimer invalidate];
	}
}

- (void) stopPanicTimer {
    if (panicTimer != nil) {
		[panicTimer invalidate];
	}
}

- (void) createTimeOutTimer {
    [self stopTimeOutTimer];
    timeOutTimer = [NSTimer scheduledTimerWithTimeInterval:[ConfigurationData timeoutApplication] target:self selector:@selector(goToNextScreen) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:timeOutTimer forMode:NSDefaultRunLoopMode];

}

- (void) createPanicTimer {
    [self stopPanicTimer];    
    
    panicTimer = [NSTimer scheduledTimerWithTimeInterval:secondsPerImage target:self selector:@selector(animateGif) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:panicTimer forMode:NSDefaultRunLoopMode];

}

- (void) createUnBlockTimer {
    [self stopPanicTimer];
    
    panicTimer = [NSTimer scheduledTimerWithTimeInterval:[ConfigurationData unblockDelay] target:self selector:@selector(goToNextScreen) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:panicTimer forMode:NSDefaultRunLoopMode];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.netTitle setMinimumFontSize:11.0];
    KeyChainHelper * keyChain = [[KeyChainHelper alloc] init];

    self.netTitle.text = [[[keyChain loadSelectedNetwork] propertyList] objectForKey:@"name"];

    secondsPerImage = ([ConfigurationData panicDelay] / 38) ;
    alarmSent = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    [self stopPanicTimer];
    
    NSSet *touchs = [event allTouches];
	NSEnumerator *enumerator = [touchs objectEnumerator];
	UITouch* touch = [enumerator nextObject];
	CGPoint touchLocation = [touch locationInView: [UIApplication sharedApplication].keyWindow];
    
	CGRect labelPosition = netTitle.frame;
	
	if (touchLocation.y > (labelPosition.origin.y + 20)) {

        if (alarmSent) {
            
            [self startScreenEnableTimer];
            
        } else {
            
            [self startAlarmSendingTimer];
            
        }
    } else {
        [self chooseNetwork];
    }
}

- (void) startScreenEnableTimer {
    
    [self stopTimeOutTimer];
    [self createUnBlockTimer];
    
}

- (void) showNextImage {
 //   UIImage * newImg = [UIImage imageNamed:[NSString stringWithFormat:@"botonpanico-%d.png", imageCounter]];
   // self.panicGifImage.image = newImg;
    
    NSString *file = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"botonpanico-%d.png", imageCounter] ofType:nil];
    
    UIImage *currentImage = [UIImage imageWithContentsOfFile:file];
    
    self.panicGifImage.image = currentImage;
    imageCounter++;

}

- (void) startAlarmSendingTimer {
    
    [self showNextImage];
    [self createPanicTimer];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)evt
{
    
    [self stopPanicTimer];

    
    if (alarmSent) {
        [self createTimeOutTimer];
    } else {
        imageCounter = 0;
        
        [self showNextImage];
    }
    


}

- (void) animateGif {
    if (imageCounter <= ANIMATED_IMAGES_COUNT) {
        
        [self showNextImage];
                                    
    } else {
        [self stopPanicTimer];
        [self showBlackScreen];
        [self sendPanicAlarm];
    }
}

- (void) sendPanicAlarm {
    alarmSent = YES;
    [self createTimeOutTimer];
    [self.serverRequestController sendPanic];
}

- (void) showBlackScreen {
    imageCounter = 0;
    self.panicGifImage.hidden = YES;
    self.icon.hidden = YES;
    self.netTitle.hidden = YES;
    self.panicScreenButton.hidden = YES;
    self.messagesScreenButton.hidden = YES;
}

- (void) goToNextScreen {
    [self.superViewController loadMessagesScreen];
}

- (void) chooseNetwork {
    [self.superViewController loadChooseNetScreen : @"PANIC"];
}

- (void) exitApplication {
    [self stopPanicTimer];

    [self stopTimeOutTimer];


    exit(0);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopPanicTimer];
    [self stopTimeOutTimer];
}


- (IBAction) showModeratorMessagesScreen :(id)sender {
    [self.superViewController loadModeratorMessagesScreen : 0];
}

@end
