//
//  AppDelegate.h
//  AutoClick
//
//  Created by uglycat on 15/3/20.
//  Copyright (c) 2015年 uglycat. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ClickPositions.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,NSTextFieldDelegate>
{
    
@private
    BOOL record;
    BOOL playingActions;
    NSTimer *clickTimer;
    NSInteger actionNumber;
    
    ClickPositions* clickPos;
    NSMutableArray* actionArray;
}

@property (assign) IBOutlet NSWindow *window;
@property (strong,nonatomic) IBOutlet NSTextField *timeField;
@property (strong,nonatomic) IBOutlet NSMenuItem *feedBack;



-(IBAction)feedBack:(id)sender;


@end

