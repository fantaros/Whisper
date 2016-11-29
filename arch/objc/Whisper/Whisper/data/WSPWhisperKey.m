//
//  WhisperKey.m
//  Whisper
//
//  Created by fantaros on 2016/11/27.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPWhisperKey.h"

@interface WSPWhisperKey()

@property (copy, nonatomic) NSArray *whisperStoredKey;
@property (copy, nonatomic) NSArray *whisperStoredRing;
@property (copy, nonatomic) NSString *password;

@property (assign, nonatomic) NSInteger keyLength;

@end

@implementation WSPWhisperKey

+ (instancetype) whisperKeyWithPassword:(NSString *)password {
    return [[WSPWhisperKey alloc] initWithPassword:password keyLength:128];
}

+ (instancetype) whisperKeyWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength {
    return [[WSPWhisperKey alloc] initWithPassword:password keyLength:keyLength];
}

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
             @0x6c, @0xf1, @0x40, @0x8
             ];
    return _WhisperTable;
}

- (NSArray *) WhisperSwapMagic {
    _WhisperSwapMagic = @[
             @27,@30,@39,@45,@54,@57,
             @75,@78,@99,@108,@114,@120,
             @135,@141,@147,@156,@177,@180,
             @198,@201,@210,@216,@225,@22
             ];
    return _WhisperSwapMagic;
}

- (NSArray *) whisperStoredKey {
    return _whisperStoredKey;
}

- (NSArray *) whisperStoredRing {
    return _whisperStoredRing;
}

- (instancetype) initWithPassword: (NSString *) password keyLength:(NSUInteger) keyLength {
    self = [super init];
    if (self) {
        self.password = password;
        self.keyLength = keyLength;
        if (self.keyLength < 128) {
            self.keyLength = 128;
        }
        [self setupKey];
        [self setupRing];
    }
    return self;
}

- (void) setupKey {
    if (self.password.length < 1) {
        self.password = @"1234567890";
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
                 [self.WhisperTable[ passwordChars[i] % 64 ] unsignedCharValue]))]
              ];
         } else {
             [mutableKeys addObject:
              [NSNumber numberWithUnsignedChar:
               ((unsigned char)
                ( ( ([mutableKeys[( i + 1 ) % len] unsignedCharValue] & 0xc0) |
                    ([mutableKeys[( i + 3 ) % len] unsignedCharValue] & 0x30) |
                    ([mutableKeys[i % len] unsignedCharValue] & 0x0c) |
                    ([mutableKeys[( i + 2 ) % len] unsignedCharValue] & 0x03) ) ^
                    [self.WhisperTable[passwordChars[i % len] % 64] unsignedCharValue]
                 )
              ) ]];
         }
     }
    self.whisperStoredKey = [mutableKeys copy];
}

- (void) setupRing {
    NSInteger i,j;
    NSMutableArray *mutableRing = [[NSMutableArray alloc] init];
    for (i = 0; i < self.whisperStoredKey.count - 1; i += 2) {
        j = i / 2;
        [mutableRing addObject:
            [NSNumber numberWithUnsignedChar:(
             (unsigned char) (self.WhisperSwapMagic[
                                                    [self regetByte1:[self.whisperStoredKey[i%self.keyLength] unsignedCharValue]
                                                               byte2:[self.whisperStoredKey[(i + 1)%self.keyLength] unsignedCharValue]]
                                                    % 24])
             )] ];
    }
    self.whisperStoredRing = [mutableRing copy];
}

- (unsigned char) regetByte1:(unsigned char) byte1 byte2:(unsigned char) byte2 {
    unsigned char ret = (unsigned char)(byte1 & 0xf0);
    ret = (unsigned char)(ret | (byte2 & 0x0f));
    return ret;
}

- (unsigned char) getKey:(NSUInteger) offset {
    return [self.whisperStoredKey[offset % self.keyLength] unsignedCharValue];
}

- (unsigned char) getRing:(NSUInteger) offset {
    return [self.whisperStoredRing[offset % 64] unsignedCharValue];
}

@end
