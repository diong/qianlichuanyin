//
//  zyprotocol.h
//  ZhiYin
//
//  Created by pro on 2018/9/27.
//  Copyright © 2018年 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface protocol_base_info : NSObject
@property(nonatomic, assign)BOOL IsSuccess;
@property(nonatomic, copy)NSString* ErrorCode;
@property(nonatomic, copy)NSString* Message;
@end

@interface QLzyprotocol_base : NSObject
+ (void)setbaseparameter:(NSMutableDictionary*)dict;
+ (void)token_base_info:(protocol_base_info*)info jsondict:(NSDictionary *)jsondict;
@end

// getnickname
@interface protocol_nickname_info : protocol_base_info
@property(nonatomic, copy)NSString* ClientID;
@property(nonatomic, copy)NSString* NickName;
@end

@interface zyprotocol_nickname : QLzyprotocol_base

+(NSString*)nickname_url;
+(NSDictionary*)nickname_parame;
+(protocol_nickname_info*)token_response:(NSDictionary*)jsondict;

@end

// send_audio
@interface protocol_sendaudio_info : protocol_base_info

@end

@interface zyprotocol_sendaudio : QLzyprotocol_base

+(NSString*)sendaudio_url;
+(NSDictionary*)sendaudio_parame:(NSData*)audiodata audiolen:(NSInteger)audiolen towhere:(NSInteger)towhere otherid:(NSString*)otherid;
+(protocol_sendaudio_info*)token_response:(NSDictionary*)jsondict;

@end

// get_tianya_audio
@interface protocol_audio_info : NSObject
@property(nonatomic, copy)NSString* audioid;
@property(nonatomic, copy)NSString* clientid;
@property(nonatomic, copy)NSString* audiourl;
@property(nonatomic, assign)NSInteger audioduration;
@property(nonatomic, assign)NSInteger towhere;
@property(nonatomic, assign)NSInteger supportcount;
@property(nonatomic, assign)NSInteger stampcount;
@property(nonatomic, copy)NSString* otherid;
@property(nonatomic, strong)NSString* createtime;
@property(nonatomic, copy)NSString* nickname;
@property(nonatomic, assign)NSInteger pre_support_type;
@property(nonatomic, assign)NSInteger now_support_type;
@end

@interface protocol_tianya_audio_info : protocol_base_info
@property(nonatomic, strong)NSArray* audio_info_list;
@end

@interface zyprotocol_tianya_audio : QLzyprotocol_base
+(NSString*)tianya_url;
+(NSDictionary*)tianya_param:(NSInteger)topnum;
+(protocol_tianya_audio_info*)token_response:(NSDictionary*)jsondict;
@end

// audio support
@interface protocol_audio_support_info : protocol_base_info

@end

@interface zyprotocol_audio_support : QLzyprotocol_base
+(NSString*)support_url;
+(NSDictionary*)support_param:(NSArray*)supportaudioids;
+(protocol_audio_support_info*)token_response:(NSDictionary*)jsondict;
@end

// audio diss_support
@interface protocol_audio_diss_support_info : protocol_base_info

@end

@interface zyprotocol_audio_diss_support : QLzyprotocol_base
+(NSString*)diss_support_url;
+(NSDictionary*)diss_support_param:(NSArray*)diss_supportaudioids;
+(protocol_audio_diss_support_info*)token_response:(NSDictionary*)jsondict;
@end

// ranklist
@interface protocol_ranklist_audio_info : protocol_base_info
@property(nonatomic, strong)NSArray* audio_info_list;
@end

@interface zyprotocol_ranklist_audio : QLzyprotocol_base
+(NSString*)ranklist_url;
+(NSDictionary*)ranklist_param:(NSInteger)topnum Period:(NSInteger)period;
+(protocol_ranklist_audio_info*)token_response:(NSDictionary*)jsondict;
@end

// isend
@interface protocol_isend_audio_info : protocol_base_info
@property(nonatomic, strong)NSArray* audio_info_list;
@end

@interface zyprotocol_isend_audio : QLzyprotocol_base
+(NSString*)isend_url;
+(NSDictionary*)isend_param:(NSInteger)topnum;
+(protocol_isend_audio_info*)token_response:(NSDictionary*)jsondict;
@end

// sendme
@interface protocol_sendme_audio_info : protocol_base_info
@property(nonatomic, strong)NSArray* audio_info_list;
@end

@interface zyprotocol_sendme_audio : QLzyprotocol_base
+(NSString*)sendme_url;
+(NSDictionary*)sendme_param:(NSInteger)topnum;
+(protocol_sendme_audio_info*)token_response:(NSDictionary*)jsondict;
@end

// complaint
@interface protocol_complaint_info : protocol_base_info

@end

@interface zyprotocol_complaint : QLzyprotocol_base
+(NSString*)complaint_url;
+(NSDictionary*)complaint_param:(NSString*)audioid complainttype:(NSInteger)type reason:(NSString*)reason;
+(protocol_complaint_info*)token_response:(NSDictionary*)jsondict;
@end

// pushblacklist
@interface protocol_pushblack_info : protocol_base_info

@end

@interface zyprotocol_pushblack : QLzyprotocol_base
+(NSString*)pushblack_url;
+(NSDictionary*)pushblack_param:(NSString*)userid;
+(protocol_pushblack_info*)token_response:(NSDictionary*)jsondict;
@end

NS_ASSUME_NONNULL_END
