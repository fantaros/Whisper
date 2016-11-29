//
//  NSData+WSPBase64.h
//  Whisper
//
//  Created by fantaros on 2016/11/28.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WSPBase64)
+ (NSData *) wspDataWithBase64EncodedString:(NSString *)string;
- (NSString *) wspBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *) wspBase64EncodedString;
@end
