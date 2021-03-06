//
//  WhisperKey.m
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperKey.h"

@interface WSPWhisperKey()

//已保存的密钥
@property (copy, nonatomic) NSArray *whisperStoredKey;
//用户密码
@property (copy, nonatomic) NSString *password;
//密钥整体的盐°计算完成标志
@property (assign, nonatomic) BOOL keySaltCalculated;
//密钥长度
@property (assign, nonatomic) NSInteger keyLength;

@end

@implementation WSPWhisperKey

@synthesize keySalt = _keySalt;

+ (instancetype) whisperKeyWithPassword:(NSString *)password {
    return [[WSPWhisperKey alloc] initWithPassword:password keyLength:163];
}

+ (instancetype) whisperKeyWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength {
    return [[WSPWhisperKey alloc] initWithPassword:password keyLength:keyLength];
}

//已初始化的whisper表，保存了公用的密钥初始化数据
- (NSArray *) WhisperTable {
    _WhisperTable = @[
             @0xd6, @0x9c, @0x2b, @0xd7, @0xbd, @0x66,
             @0xb5, @0xf9, @0x27, @0xb7, @0x02, @0x86,
             @0x68, @0x79, @0xa3, @0xfe, @0x0f, @0x78,
             @0xa8, @0x8e, @0x7d, @0xc5, @0x99, @0x25,
             @0xc3, @0x20, @0xc8, @0xbf, @0x80, @0x6e,
             @0x6b, @0xbe, @0xd1, @0xb7, @0x7a, @0x50,
             @0xe3, @0xa4, @0x52, @0x60, @0x5a, @0x26,
             @0xb4, @0x1e, @0xaf, @0x73, @0xb1, @0x07,
             @0x2d, @0x76, @0xc6, @0x9e, @0xa3, @0x6c,
             @0x71, @0x23, @0x38, @0x6f, @0xcb, @0x63,
             @0x6c, @0xf1, @0x40, @0x82
             ];
    return _WhisperTable;
}

- (NSArray *) whisperStoredKey {
    return _whisperStoredKey;
}

- (instancetype) initWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength {
    self = [super init];
    if (self) {
        self.password = password;
        self.keyLength = keyLength;
        _keySaltCalculated = NO;
        if (self.keyLength < 163) {
            self.keyLength = 163;
        }
        [self setupKey];
    }
    return self;
}

//密钥整体的盐°
- (unsigned char) keySalt {
    if (!_keySaltCalculated) {
        _keySalt = [self calculateSalt:self.whisperStoredKey];
        _keySaltCalculated = YES;
    }
    return _keySalt;
}

//计算某个字节数组的盐°
- (unsigned char) calculateSalt:(NSArray *) src {
    if (src == nil) {
        return 0;
    }
    unsigned char salt = [self getKey:0];
    for (NSInteger i = 0; i < src.count; ++i) {
        unsigned char key = [self getKey:i];
        unsigned char val = [src[i] unsignedCharValue];
        salt = (((salt * val) ^ key) % 256);
    }
    return (unsigned char)(salt ^ [self getKey:(self.whisperStoredKey.count - 1)]);
}

- (void) setupKey {
    if (self.password.length < 1) {
        self.password = @"???????";
    }
    NSData *passwordData = [self.password dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger len = passwordData.length;
    unsigned char passwordChars[len];
    [passwordData getBytes:passwordChars length:len];
     NSMutableArray *mutableKeys = [[NSMutableArray alloc] init];
     NSInteger i = 0;
     for (; i < self.keyLength; ++i) {
         if (i < len) {
             [mutableKeys addObject:
              [NSNumber numberWithUnsignedChar:
               ((unsigned char)
                (passwordChars[i] ^
                 [self.WhisperTable[ passwordChars[i] % self.WhisperTable.count ] unsignedCharValue]))]
              ];
         } else {
             [mutableKeys addObject:
              [NSNumber numberWithUnsignedChar:
               ((unsigned char)
                ( ( ([mutableKeys[( i + 1 ) % len] unsignedCharValue] & 0xc0) |
                    ([mutableKeys[( i + 3 ) % len] unsignedCharValue] & 0x30) |
                    ([mutableKeys[i % len] unsignedCharValue] & 0x0c) |
                    ([mutableKeys[( i + 2 ) % len] unsignedCharValue] & 0x03) ) ^
                    [self.WhisperTable[passwordChars[i % len] % self.WhisperTable.count] unsignedCharValue]
                 )
              ) ]];
         }
     }
    self.whisperStoredKey = [mutableKeys copy];
    if (!_keySaltCalculated) {
        _keySalt = [self calculateSalt:self.whisperStoredKey];
        _keySaltCalculated = YES;
    }
}

- (unsigned char) regetByte1:(unsigned char) byte1 byte2:(unsigned char) byte2 {
    unsigned char ret = (unsigned char)(byte1 & 0xf0);
    ret = (unsigned char)(ret | (byte2 & 0x0f));
    return ret;
}

//利用明文的信息对key再构造，并返回结构转换数组
- (NSArray *) recook:(NSUInteger) outputLength blockSize:(NSUInteger) blockSize{
    if (self.whisperStoredKey != nil) {
        if (outputLength < 0) {
            outputLength = abs(outputLength);
        }
        unsigned char seed = (unsigned char)(outputLength % 256);
        NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:self.whisperStoredKey.count];
        for (NSInteger i = 0; i < self.whisperStoredKey.count; ++i) {
            NSNumber *val = self.whisperStoredKey[i];
            [keys addObject:[NSNumber numberWithUnsignedChar:(unsigned char)([val unsignedCharValue] ^ seed)]];
        }
        self.whisperStoredKey = keys;
        NSUInteger blockCount = ((NSUInteger)outputLength / blockSize);
        return [self buildSwapArray:blockCount salt:0];
    }
    return nil;
}

//输出乱序排列数组
- (NSArray *) buildSwapArray:(NSUInteger) seed salt:(NSUInteger) salt{
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:
                              seed];
    for (NSInteger i = 0; i < seed; ++i) {
        [result addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    //乱序过程
    NSUInteger tmp;
    for (NSInteger o = seed - 1; o > 0; o = o - 1) {
        NSUInteger j = (NSUInteger)(((NSInteger)(([self getKey:[self getRing:(o ^ salt)]] / 256.0) * o)) % seed);
        tmp = [result[o] unsignedIntegerValue];
        result[o] = [result[j] copy];
        result[j] = [NSNumber numberWithUnsignedInteger:tmp];
    }
    return [result copy];
}

//获得offset位置的密钥
- (unsigned char) getKey:(NSUInteger) offset {
    return [self.whisperStoredKey[offset % self.keyLength] unsignedCharValue];
}
//获得offset位置的已加工密钥
- (unsigned char) getRing:(NSUInteger) offset {
    return [self.whisperStoredKey[(offset ^ self.keyLength) % self.keyLength] unsignedCharValue];
}

@end
