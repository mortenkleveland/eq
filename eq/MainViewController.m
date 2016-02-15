//
//  MainViewController.m
//  eq
//
//  Created by Morten Kleveland on 15.02.2016.
//  Copyright © 2016 Morten Kleveland. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (void) awakeFromNib {
    
    //setup code
    NSLog(@"hello there");
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    // Disregard parameters - nib name is an implementation detail
    return [super init];
}

@end
