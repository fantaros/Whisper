//
//  WhisperAlogrithm.m
//  Whisper
//
//  Created by fantaros on 2016/11/21.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperAlgorithm.h"
#import "WSPWhisperBlock4.h"

@interface WSPWhisperAlgorithm ()

@property (strong, nonatomic) WSPWhisperBlock4 *block;

@end

@implementation WSPWhisperAlgorithm

- (WSPWhisperData *) encrypto:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        NSInteger len = org.count;
        NSInteger olen = (NSInteger)((len / 4.0) + 0.9) * 4;
        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity:olen];
        self.block = [WSPWhisperBlock4 whisperBlock4];
        NSInteger j;
        for (NSInteger i = 0; i < org.count; i += 4) {
            [self.block refreshDataWithBigByteArray:org offset:i];
            unsigned char ring = [password getRing:i];
            unsigned char key;
            [self.block blockSwap:ring];
            for (j = 0; j < 4; ++j) {
                key = [password getKey:(i + j)];
                [self.block whispingWithOffset:j function:[password getKey:key] keys:key];
            }
            [oData acceptByteArray:self.block.bytes startOffset:i];
        }
        return oData;
    }
    return nil;
}

- (WSPWhisperData *) decrypto:(WSPWhisperData *)baseData key:(WSPWhisperKey *) password {
    NSArray *org = baseData.byteArray;
    if (org != nil) {
        NSInteger len = org.count;
        WSPWhisperData *oData = [WSPWhisperData whisperDataWithCapacity:len];
        self.block = [WSPWhisperBlock4 whisperBlock4];
        NSInteger j;
        for (NSInteger i = 0; i < org.count; i += 4) {
            [self.block refreshDataWithBigByteArray:org offset:i];
            unsigned char ring = [password getRing:i];
            unsigned char key;
            for (j = 0; j < 4; ++j) {
                key = [password getKey:(i + j)];
                [self.block whispingWithOffset:j function:[password getKey:key] keys:key];
            }
            [self.block deBlockSwap:ring];
            [oData acceptByteArray:self.block.bytes startOffset:i];
        }
        return oData;
    }
    return nil;
}

@end
