//
//  Logix.m
//  Whisper
//
//  Created by fantaros on 2016/11/17.
//  Copyright © 2016年 fantaros. All rights reserved.
//

#import "WSPLogix.h"

@interface WSPLogix()

@property (copy, nonatomic) NSArray *logixTable;

@end

@implementation WSPLogix

-(instancetype) init {
    self = [super init];
    if (self) {
        //MagicNo is 1989215
        [self setupSelfWithSeed: 1989215];
    }
    return self;
}

-(instancetype) initWithSeed:(NSInteger) seed {
    self = [super init];
    if (self) {
        [self setupSelfWithSeed:seed];
    }
    return self;
}

-(unsigned char) cookOffset:(NSUInteger) offset withSeed:(NSInteger) seed {
    // 0x03E5 = 997
    // 0x3CB5 = 15541
    // 0x6EF3 = 28403
    // 0x003B = 59
    NSUInteger offsetCast = offset * 997 + 15541;
    NSUInteger wSeed = 28403 + (seed ^ offsetCast) * 59;
    return (unsigned char)(wSeed % 256);
}

-(void) setupSelfWithSeed:(NSInteger) seed {
    NSMutableArray *seedArray = [[NSMutableArray alloc] initWithCapacity:256];
    NSUInteger i;
    for (i = 0; i < 256; ++i) {
        [seedArray addObject: [NSNumber numberWithUnsignedChar:i]];
    }
    for (i = 0; i < 32; ++i) {
        seedArray[i] = [NSNumber numberWithUnsignedChar:(unsigned char)([seedArray[[self cookOffset:i withSeed:seed]] unsignedCharValue] ^ [seedArray[i] unsignedCharValue])];
        seedArray[[self cookOffset:i withSeed:seed]] = [NSNumber numberWithUnsignedChar:(unsigned char)([seedArray[[self cookOffset:i withSeed:seed]] unsignedCharValue] ^ [seedArray[i] unsignedCharValue])];
        seedArray[i] = [NSNumber numberWithUnsignedChar:(unsigned char)([seedArray[[self cookOffset:i withSeed:seed]] unsignedCharValue] ^ [seedArray[i] unsignedCharValue])];
    }
    _logixTable = seedArray;
}

//返回某个部分异或映射
-(unsigned char) mappedLogixTableH:(unsigned char) src {
    return [[_logixTable objectAtIndex:((NSInteger)(src & 31))] unsignedCharValue];
}

//通过部分异或映射计算两个操作数的结果
-(unsigned char) logixWithOperatorByte1:(unsigned char) opt1 operatorByte2:(unsigned char) opt2 methodType:(unsigned char) methodNo {
    return (unsigned char)(((NSInteger)opt1) ^ ((NSInteger)opt2) ^ ((NSInteger)[self mappedLogixTableH:methodNo]));
}

@end
