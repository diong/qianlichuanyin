//
//  TPAACAudioConverter.h
//
//  Created by Michael Tyson on 02/04/2011.
//  Copyright 2011 A Tasty Pixel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

extern NSString * TPAACAudioConverterErrorDomain;

enum {
    TPAACAudioConverterFileError,
    TPAACAudioConverterFormatError,
    TPAACAudioConverterUnrecoverableInterruptionError,
    TPAACAudioConverterInitialisationError
};

@protocol TPAACAudioConverterDelegate;
@protocol TPAACAudioConverterDataSource;

@interface QLTPAACAudioConverter : NSObject

+ (BOOL)AACConverterAvailable;

- (id)initWithDelegate:(id<TPAACAudioConverterDelegate>)delegate source:(NSString*)sourcePath destination:(NSString*)destinationPath;
- (id)initWithDelegate:(id<TPAACAudioConverterDelegate>)delegate dataSource:(id<TPAACAudioConverterDataSource>)dataSource audioFormat:(AudioStreamBasicDescription)audioFormat destination:(NSString*)destinationPath;
- (void)start;
- (void)cancel;

- (void)interrupt;
- (void)resume;

@property (nonatomic, readonly, strong) NSString *source;
@property (nonatomic, readonly, strong) NSString *destination;
@property (nonatomic, readonly) AudioStreamBasicDescription audioFormat;
@end


@protocol TPAACAudioConverterDelegate <NSObject>
- (void)AACAudioConverterDidFinishConversion:(QLTPAACAudioConverter*)converter;
- (void)AACAudioConverter:(QLTPAACAudioConverter*)converter didFailWithError:(NSError*)error;
@optional
- (void)AACAudioConverter:(QLTPAACAudioConverter*)converter didMakeProgress:(float)progress;
@end

@protocol TPAACAudioConverterDataSource <NSObject>
- (void)AACAudioConverter:(QLTPAACAudioConverter*)converter nextBytes:(char*)bytes length:(NSUInteger*)length;
@optional
- (void)AACAudioConverter:(QLTPAACAudioConverter *)converter seekToPosition:(NSUInteger)position;
@end
