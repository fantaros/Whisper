//
//  WhisperDataSequence.h
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WhisperData : NSObject

+ (instancetype) whisperData;
+ (instancetype) whisperDataWithUnsignedCharArray:(NSArray *)array;

- (NSMutableArray *) byteArray;
- (void) setByteArray:(NSMutableArray *)byteArray;

- (void) addUnsignedCharValue:(unsigned char) value;

- (void) addNumber:(NSNumber *) number;

- (void) insertResultData:(NSArray *)array atIndexes:(NSIndexSet *)indexes;

- (NSInteger) dataLength;

- (unsigned char) unsignedCharValueAtIndex:(NSUInteger) offset;

@end
