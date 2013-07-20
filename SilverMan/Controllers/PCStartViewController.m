//
//  StartViewController.m
//  SilverMan
//
//  Created by Willy on 19.12.12.
//  Copyright (c) 2012 Willy. All rights reserved.
//

#import "PCStartViewController.h"


@implementation PCStartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    imageView.image = [UIImage textureNamed:@"metalBackground"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight || interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
