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
//        NSDate *now = [[NSDate alloc] init];
//        NSInteger seed = (NSInteger)((NSInteger)[now timeIntervalSince1970] % 65536);
        NSInteger seed = 198848;
        [self setupSelfWithSeed: seed];
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

-(unsigned char) cookOffset:(NSUInteger) offset withSeed:(unsigned char) seed {
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

-(unsigned char) mappedLogixTableH:(unsigned char) src {
    return [[_logixTable objectAtIndex:((NSInteger)(src & 31))] unsignedCharValue];
}

-(unsigned char) logixWithOperatorByte1:(unsigned char) opt1 operatorByte2:(unsigned char) opt2 methodType:(unsigned char) methodNo {
    return (unsigned char)(opt1 ^ opt2 ^ [self mappedLogixTableH:methodNo]);
}

@end
