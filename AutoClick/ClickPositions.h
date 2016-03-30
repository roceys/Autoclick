//
//  ClickPositions.h
//  AutoClick
//
//  Created by uglycat on 15/3/20.
//  Copyright (c) 2015年 uglycat. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SCREEN_FRAME [[NSScreen mainScreen] frame]

enum {
    LEFT_BUTTON=0,
    RIGHT_BUTTOM=1,
    LEFT_MOUSE_DRAGGED=2,
    RIGHT_MOUSE_DRAGGED=3
    
};
typedef uint32_t BUTTON_TYPE;



@interface ClickPositions : NSObject
{
    
    uint32_t buttonType;
    CGPoint clickPosition;
    
}

@property (assign,nonatomic)uint32_t buttonType;
@property (assign,nonatomic)CGPoint clickPosition;


@end
