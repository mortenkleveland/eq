//
//  AppDelegate.m
//  eq
//
//  Created by Morten Kleveland on 15.02.2016.
//  Copyright © 2016 Morten Kleveland. All rights reserved.
//

// http://stackoverflow.com/questions/1726250/nsviewcontroller-and-multiple-subviews-from-a-nib

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (assign, nonatomic) BOOL darkModeOn;
@property (strong, nonatomic) NSPopover *popover;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    // Add image to status bar
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.image = [NSImage imageNamed:@"bat"];
    [self.statusItem.image setTemplate:YES];
    
    [self.statusItem setAction:@selector(itemClicked:)];
    [self refreshDarkMode];
    
    // Add custom view to popup
    NSViewController* mainViewController = [[NSViewController alloc]initWithNibName:@"MainViewController" bundle:nil];
    [self.window setContentView:mainViewController.view];
    self.popover = [[NSPopover alloc]init];
    self.popover.contentViewController = mainViewController;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [NSApp terminate:self];
}

- (void)refreshDarkMode {
    NSString * value = (__bridge NSString *)(CFPreferencesCopyValue((CFStringRef)@"AppleInterfaceStyle", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost));
    if ([value isEqualToString:@"Dark"]) {
        self.darkModeOn = YES;
    } else {
        self.darkModeOn = NO;
    }
}

- (void)lol {
    
}

- (void)showPopover:(id)sender {
//    NSButton* button = (NSButton*)sender;
//    if (self.statusItem.button == button) {
    NSRect bounds = self.statusItem.button.bounds;
        [self.popover showRelativeToRect:bounds ofView:self.statusItem.button preferredEdge:NSMinYEdge];
//    }
}

- (void)closePopover:(id)sender {
    [self.popover performClose:sender];
}

- (void)togglePopover:(id)sender {
    if ([self.popover isShown]) {
        [self closePopover:sender];
    } else {
        [self showPopover:sender];
    }
}

- (void)itemClicked:(id)sender {
    // Open popover view
    [self togglePopover:sender];
    
    // Handle ctrl-click (eventually right click menu???)
    NSEvent *event = [NSApp currentEvent];
    if([event modifierFlags] & NSControlKeyMask) {
        [[NSApplication sharedApplication] terminate:self];
        return;
    }
    
    _darkModeOn = !_darkModeOn; //Change pref
    if (self.darkModeOn) {
        CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", @"Dark", kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    } else {
        CFPreferencesSetValue((CFStringRef)@"AppleInterfaceStyle", NULL, kCFPreferencesAnyApplication, kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    } //update listeners
    dispatch_async(dispatch_get_main_queue(), ^{ CFNotificationCenterPostNotification(CFNotificationCenterGetDistributedCenter(), (CFStringRef)@"AppleInterfaceThemeChangedNotification", NULL, NULL, YES);
    });
}

@end
