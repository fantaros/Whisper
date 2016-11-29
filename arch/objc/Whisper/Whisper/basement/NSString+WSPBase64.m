//
//  NSString+WSPBase64.m
//  Whisper
//
//  Created by fantaros on 2016/11/28.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "NSString+WSPBase64.h"
#import "NSData+WSPBase64.h"

@implementation NSString (WSPBase64)

+ (NSString *) wspStringWithBase64EncodedString:(NSString *)string {
    NSData *data = [NSData wspDataWithBase64EncodedString:string];
    if (data) {
        NSString *result = [[self alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
#if !__has_feature(objc_arc)
        [result autorelease];
#endif
        
        return result;
    }
    return nil;
}

- (NSString *) wspBase64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data wspBase64EncodedStringWithWrapWidth:wrapWidth];
}

- (NSString *) wspBase64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    return [data wspBase64EncodedString];
}

- (NSString *) wspBase64DecodedString {
    return [NSString wspStringWithBase64EncodedString:self];
}

- (NSData *) wspBase64DecodedData {
    return [NSData wspDataWithBase64EncodedString:self];
}

@end
