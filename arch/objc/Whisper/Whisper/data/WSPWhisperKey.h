//
//  WhisperKey.h
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSPWhisperKey : NSObject

+ (instancetype) whisperKeyWithPassword: (NSString *) password;
+ (instancetype) whisperKeyWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength;

@property (copy, nonatomic) NSArray *WhisperTable;
@property (copy, nonatomic) NSArray *WhisperSwapMagic;

- (unsigned char) getKey:(NSUInteger) offset;

- (unsigned char) getRing:(NSUInteger) offset;

@end
