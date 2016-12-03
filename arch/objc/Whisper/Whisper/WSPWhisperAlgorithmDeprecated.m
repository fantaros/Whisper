//
//  WhisperAlogrithm.m
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperAlgorithmDeprecated.h"
#import "WSPWhisperBlockDeprecated.h"

@interface WSPWhisperAlgorithmDeprecated()

@end

@implementation WSPWhisperAlgorithmDeprecated

+ (instancetype) whisperAlgorithm {
    return [[WSPWhisperAlgorithmDeprecated alloc] init];
}

- (WSPWhisperData *) encryptWithBlockSize4:(WSPWhisperData *)baseData key:(WSPWhisperKeyDeprecated *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        NSInteger len = org.count;
        NSInteger olen = (NSInteger)((len / 4.0) + 0.9) * 4;
        NSArray *blockArray = [password recook:olen blockSize:4];
//        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity: olen];
        WSPWhisperData *oData = [WSPWhisperData whisperData];
        WSPWhisperBlockDeprecated *block = [WSPWhisperBlockDeprecated whisperBlock4];
        NSInteger j;
        NSUInteger location = 0;
        for (NSInteger i = 0; i < blockArray.count; ++i) {
            NSUInteger offset = [blockArray[i] unsignedIntegerValue] * 4;
            [block refreshDataWithBigByteArray:org offset:offset];
            unsigned char ring = [password getRing:((NSInteger)(location / 4))];
            unsigned char key;
            [block blockSwap:ring];
            for (j = 0; j < 4; ++j) {
                key = [password getKey:(location + j)];
                [block whispingWithOffset:j keys:key function:[password getKey:key]];
            }
            [oData acceptByteArray:block.bytes startOffset:location blockSize:4];
            location = location + 4;
        }
        return oData;
    }
    return nil;
}

- (WSPWhisperData *) decryptWithBlockSize4:(WSPWhisperData *)baseData key:(WSPWhisperKeyDeprecated *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        NSInteger len = org.count;
        NSArray *blockArray = [password recook:len blockSize:4];
        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity:len];
        WSPWhisperBlockDeprecated *block = [WSPWhisperBlockDeprecated whisperBlock4];
        NSInteger j;
        NSUInteger location = 0;
        for (NSInteger i = 0; i < blockArray.count; ++i) {
            NSUInteger offset = [blockArray[i] unsignedIntegerValue] * 4;
            [block refreshDataWithBigByteArray:org offset:location];
            unsigned char ring = [password getRing:((NSInteger)(location / 4))];
            unsigned char key;
            for (j = 0; j < 4; ++j) {
                key = [password getKey:(location + j)];
                [block whispingWithOffset:j keys:key function:[password getKey:key]];
            }
            [block deBlockSwap:ring];
            [oData deAcceptByteArray:block.bytes startOffset:offset blockSize:4];
            location = location + 4;
        }
        return oData;
    }
    return nil;
}

@end
