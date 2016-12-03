//
//  WhisperAlogrithm.m
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperAlgorithm.h"
#import "WSPWhisperBlock4.h"

@implementation WSPWhisperAlgorithm

+ (instancetype) whisperAlgorithm {
    return [[WSPWhisperAlgorithm alloc] init];
}

- (WSPWhisperData *) encrypto:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        NSInteger len = org.count;
        NSInteger olen = (NSInteger)((len / 4.0) + 0.9) * 4;
        [password recook:olen];
        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity: olen];
        WSPWhisperBlock4 *block = [WSPWhisperBlock4 whisperBlock4];
        NSInteger j;
        for (NSInteger i = 0; i < org.count; i += 4) {
            [block refreshDataWithBigByteArray:org offset:i];
            unsigned char ring = [password getRing:((NSInteger)(i/4))];
            unsigned char key;
            [block blockSwap:ring];
            for (j = 0; j < 4; ++j) {
                key = [password getKey:(i + j)];
                [block whispingWithOffset:j keys:key function:[password getKey:key]];
            }
            [oData acceptByteArray:block.bytes startOffset:i];
        }
        return oData;
    }
    return nil;
}

- (WSPWhisperData *) decrypto:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        NSInteger len = org.count;
        [password recook:len];
        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity:len];
        WSPWhisperBlock4 *block = [WSPWhisperBlock4 whisperBlock4];
        NSInteger j;
        for (NSInteger i = 0; i < org.count; i += 4) {
            [block refreshDataWithBigByteArray:org offset:i];
            unsigned char ring = [password getRing:((NSInteger)(i/4))];
            unsigned char key;
            for (j = 0; j < 4; ++j) {
                key = [password getKey:(i + j)];
                [block whispingWithOffset:j keys:key function:[password getKey:key]];
            }
            [block deBlockSwap:ring];
            [oData acceptByteArray:block.bytes startOffset:i];
        }
        return oData;
    }
    return nil;
}

@end
