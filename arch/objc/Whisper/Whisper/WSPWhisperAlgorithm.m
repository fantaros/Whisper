//
//  WhisperAlogrithm.m
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperAlgorithm.h"
#import "WSPWhisperBlock.h"

@interface WSPWhisperAlgorithm()

@property (nonatomic, assign) NSUInteger blockSize;

@end

@implementation WSPWhisperAlgorithm

+ (instancetype) whisperAlgorithm {
    return [[WSPWhisperAlgorithm alloc] initWithBlockSize:3];
}

+ (instancetype) whisperAlgorithmWithBlockSize:(NSUInteger) blockSize {
    return [[WSPWhisperAlgorithm alloc] initWithBlockSize:blockSize];
}

- (instancetype) initWithBlockSize:(NSUInteger) blockSize {
    self = [super init];
    if (self) {
        self.blockSize = blockSize;
    }
    return self;
}

-(NSUInteger) blockSize {
    if (_blockSize < 1) {
        return WHISPER_DEFAULT_BLOCKSIZE;
    }
    return _blockSize;
}

//Whisper加密
- (WSPWhisperData *) encrypt:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password {
    NSArray *byteData = baseData.byteArray;
    if (byteData != nil) {
        NSInteger len = byteData.count;
        NSInteger olen = (NSInteger)((len / ((double)self.blockSize)) + 0.9) * self.blockSize;
        NSArray *blockArray = [password recook:olen blockSize:self.blockSize];
        WSPWhisperData *oData = [WSPWhisperData whisperData];
        WSPWhisperBlock *block = [WSPWhisperBlock whisperBlock:self.blockSize];
        NSInteger j;
        NSUInteger location = 0;
        unsigned char dataSalt = (unsigned char)([password calculateSalt:byteData] ^ password.keySalt);
        NSMutableArray *data = [[NSMutableArray alloc] initWithArray:byteData];
        for (NSInteger i = 0; i < len; ++i) {
            unsigned char ad = [data[i] unsignedCharValue];
            data[i] = [NSNumber numberWithUnsignedChar:(ad ^ dataSalt)];
        }
        if (olen > len) {
            for (NSInteger i = 0; i < (olen - len); ++i) {
                [data addObject:[NSNumber numberWithUnsignedChar:(0 ^ dataSalt)]];
            }
        }
        for (NSInteger i = 0; i < blockArray.count; ++i) {
            NSUInteger offset = [blockArray[i] unsignedIntegerValue] * self.blockSize;
            [block refreshDataWithBigByteArray:data offset:offset];
            unsigned char ring = [password getRing:((NSInteger)(location / self.blockSize))];
            unsigned char key;
            [block blockSwapWithKey:password salt:ring];
            for (j = 0; j < self.blockSize; ++j) {
                key = [password getKey:(location + j)];
                [block whispingOnOffset:j keys:key function:[password getKey:key]];
            }
            [oData acceptByteArray:block.bytes startOffset:location blockSize:self.blockSize];
            location = location + self.blockSize;
        }
        
        [oData addNumber:[NSNumber numberWithUnsignedChar:(dataSalt ^ [password getKey:0])]];
        return oData;
    }
    return nil;
}

//Whisper解密
- (WSPWhisperData *) decrypt:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password {
    NSArray *byteData = baseData.byteArray;
    if (byteData != nil) {
        NSInteger len = byteData.count - 1;
        NSArray *blockArray = [password recook:len blockSize:self.blockSize];
        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity:len];
        WSPWhisperBlock *block = [WSPWhisperBlock whisperBlock:self.blockSize];
        NSInteger j;
        NSUInteger location = 0;
        unsigned char dataSalt = [byteData[byteData.count - 1] unsignedCharValue]  ^ [password getKey:0];
        for (NSInteger i = 0; i < blockArray.count; ++i) {
            NSUInteger offset = [blockArray[i] unsignedIntegerValue] * self.blockSize;
            [block refreshDataWithBigByteArray:byteData offset:location];
            unsigned char ring = [password getRing:((NSInteger)(location / self.blockSize))];
            unsigned char key;
            for (j = 0; j < self.blockSize; ++j) {
                key = [password getKey:(location + j)];
                [block whispingOnOffset:j keys:key function:[password getKey:key]];
            }
            [block deBlockSwapWithKey:password salt:ring];
            [oData deAcceptByteArray:block.bytes startOffset:offset blockSize:self.blockSize];
            location = location + self.blockSize;
        }
        
        [oData lightDataWithSalt:dataSalt];
        return oData;
    }
    return nil;
}

@end
