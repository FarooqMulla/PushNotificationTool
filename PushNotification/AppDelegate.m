//
//  AppDelegate.m
//  PushNotificationTool
//
//  Created by Mulla, Farooq on 11/15/14.
//  Copyright (c) 2014 Mulla. All rights reserved.
//

#import "AppDelegate.h"
#import <Foundation/Foundation.h>

#import "HomeView.h"

@interface AppDelegate ()

@property (nonatomic, weak) IBOutlet HomeView *homeView;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [_window makeKeyWindow];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
}

@end
