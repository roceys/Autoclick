//
//  AppDelegate.m
//  AutoClick
//
//  Created by uglycat on 15/3/20.
//  Copyright (c) 2015年 uglycat. All rights reserved.
//

#import "AppDelegate.h"
#import "DDHotKeyCenter.h"
#import <Carbon/Carbon.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize timeField = _timeField;
@synthesize feedBack = _feedBack;



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    record = NO;
    playingActions = NO;
    
    [self hotKeyRegisterCTRL_S];
    [self hotKeyRegisterCTRL_R];
    
    actionArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    [NSEvent addGlobalMonitorForEventsMatchingMask:
     NSLeftMouseDownMask |
     NSRightMouseDownMask  handler:^(NSEvent *event) {
         
         //NSMouseMovedMask |
         //NSLeftMouseDraggedMask |
         //NSRightMouseDraggedMask

         if (record == YES) {
         
             clickPos = [[ClickPositions alloc] init];
             
             switch (event.type) {
                 case NSLeftMouseDown:
                     clickPos.buttonType = LEFT_BUTTON;
                     CGPoint x = CGPointMake(event.locationInWindow.x, SCREEN_FRAME.size.height-event.locationInWindow.y);
                     clickPos.clickPosition = x;
                     break;
                 case NSRightMouseDown:
                     clickPos.buttonType = RIGHT_BUTTOM;
                     CGPoint xx = CGPointMake(event.locationInWindow.x, SCREEN_FRAME.size.height-event.locationInWindow.y);
                     clickPos.clickPosition = xx;
                     break;
                 case NSLeftMouseDragged:
                     clickPos.buttonType = LEFT_MOUSE_DRAGGED;
                     
                     break;
                 case NSRightMouseDragged:
                     clickPos.buttonType = RIGHT_MOUSE_DRAGGED;
                     
                     break;
                 default:
                     break;
             }
             
             [actionArray addObject:clickPos];
         }
         
     }];
     
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}



- (void)recordButtonClicked{
    
    if (!record) {
        record = YES;
        [actionArray removeAllObjects];
    }
    else{
        record = NO;
    }
    
}


-(void)startButtonClicked{
    
    playingActions = YES;
    [self actionPlaying];
    
}

-(void)stopButtonClicked{
    
    playingActions = NO;
    [clickTimer invalidate];
}

- (void) hotKeyRegisterCTRL_R{
    
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    if (![c registerHotKeyWithKeyCode:kVK_ANSI_R modifierFlags:NSAlternateKeyMask target:self action:@selector(recordButtonClicked) object:nil]) {
        NSAlert *alertDefult = [[NSAlert alloc]init];
        [alertDefult setMessageText:@"Error!"];
        [alertDefult setInformativeText:@"Unable to register option+r"];
        [alertDefult addButtonWithTitle:@"OK!"];
    } else {
        
        
    }
}

- (void) hotKeyRegisterCTRL_S{
    
    DDHotKeyCenter *c = [DDHotKeyCenter sharedHotKeyCenter];
    if (![c registerHotKeyWithKeyCode:kVK_ANSI_S modifierFlags:NSAlternateKeyMask target:self action:@selector(hotkeyWithEventPlay:) object:nil]) {
        NSAlert *alertDefult = [[NSAlert alloc]init];
        [alertDefult setMessageText:@"Error!"];
        [alertDefult setInformativeText:@"Unable to register option+s"];
        [alertDefult addButtonWithTitle:@"OK!"];
    } else {
        
        
    }
}


- (void)hotkeyWithEventPlay:(NSEvent *)hotKeyEvent{
    if (!playingActions) {
        [self startButtonClicked];
        record = NO;
    }
    else{
        [self stopButtonClicked];
    }
}


-(void)actionPlaying{
    
    actionNumber = 0;
    double interval = 0.5f;
    
    if ([_timeField.stringValue length] > 0) {
        interval = [_timeField.stringValue floatValue];
    }
    
    
    
    clickTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(PostMouseEvent:) userInfo:nil repeats:YES];
    
}
-(void) PostMouseEvent:(id)sender{
    
    ClickPositions *tmpClickPos = [[ClickPositions alloc] init];
    tmpClickPos = [actionArray objectAtIndex:actionNumber];
    

    CGMouseButton button = tmpClickPos.buttonType;
    const CGPoint point = tmpClickPos.clickPosition;
    
    
    CGEventType typeUp;
    CGEventType typeDown;
    
    
    switch (button) {
        case kCGMouseButtonLeft:
            typeDown = kCGEventLeftMouseDown;
            typeUp = kCGEventLeftMouseUp;
            break;
        case kCGMouseButtonRight:
            typeDown = kCGEventRightMouseDown;
            typeUp = kCGEventRightMouseUp;
            break;
        default:
            break;
    }
    
    
    CGEventRef downEvent = CGEventCreateMouseEvent(NULL, typeDown, point, button);
    CGEventSetType(downEvent, typeDown);
    CGEventPost(kCGHIDEventTap, downEvent);
    CFRelease(downEvent);
    
    CGEventRef upEvent = CGEventCreateMouseEvent(NULL, typeUp, point, button);
    CGEventSetType(upEvent, typeUp);
    CGEventPost(kCGHIDEventTap, upEvent);
    CFRelease(upEvent);
    
    if (actionNumber == [actionArray count]-1) {
        actionNumber=0;
    }
    else{
        actionNumber++;
    }
    
}


-(IBAction)feedBack:(id)sender{
    
    
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:app@highsoda.com"]];
}


@end
