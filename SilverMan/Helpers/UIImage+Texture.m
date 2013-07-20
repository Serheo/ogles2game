//
//  UIImage+Texture.m
//  SilverMan
//
//  Created by Willy on 20.12.12.
//  Copyright (c) 2012 Willy. All rights reserved.
//

#import "UIImage+Texture.h"

@implementation UIImage (Texture)

+ (UIImage *)textureNamed:(NSString *)textureName
{
    if ([[UIScreen mainScreen] bounds].size.height == 568) return [UIImage imageNamed:[NSString stringWithFormat:@"%@-568h@2x.png", textureName]];
    return [UIImage imageNamed:textureName];
}

@end