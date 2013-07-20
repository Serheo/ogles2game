//
//  PCGameContollerProtocol.h
//  SilverMan
//
//  Created by Willy on 04.01.13.
//  Copyright (c) 2013 Willy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PCGameContollerProtocol

-(void) level:(NSString *)levelName didFinishWithResult:(BOOL)success;
@end
