//
//  NSString+WSPBase64.h
//  Whisper
//
//  Created by fantaros on 2016/11/28.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WSPBase64)

+ (NSString *) wspStringWithBase64EncodedString:(NSString *)string;
- (NSString *) wspBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *) wspBase64EncodedString;
- (NSString *) wspBase64DecodedString;
- (NSData *) wspBase64DecodedData;

@end
