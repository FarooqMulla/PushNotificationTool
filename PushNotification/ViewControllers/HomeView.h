//
//  HomeView.h
//  PushNotificationTool
//
//  Created by Mulla, Farooq on 11/15/14.
//  Copyright (c) 2014 Mulla. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HomeView;

@interface HomeView : NSView
{
    IBOutlet NSView *myTargetView; // the host view
}
@property (nonatomic, weak) HomeView *jxxHomeViewController;

@end
