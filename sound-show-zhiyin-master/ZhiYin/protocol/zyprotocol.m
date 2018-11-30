//
//  zyprotocol.m
//  ZhiYin
//
//  Created by pro on 2018/9/27.
//  Copyright © 2018年 zy. All rights reserved.
//

#import "zyprotocol.h"
#import "QLglobalvar.h"
#import "MJExtension.h"
#import "QLcryptotool.h"

#define PRO_PARAM_OSTYPE    @"ATOSType"
#define PRO_PARAM_OSVER     @"ATOSVer"
#define PRO_PARAM_APPNAME   @"ATAppName"
#define PRO_PARAM_APPVER    @"ATAppVer"
#define PRO_PARAM_UDID      @"ATUdid"
#define PRO_PARAM_SIGN      @"ATSignature"

#define PRO_HOST_URL  @"https://zyapi.alry.cn"

@implementation protocol_base_info

@end

@implementation QLzyprotocol_base

+ (void)setbaseparameter:(NSMutableDictionary*)dict {
    [dict setObject:[QLglobalvar shareglobalvar].ostype forKey:PRO_PARAM_OSTYPE];
    [dict setObject:[QLglobalvar shareglobalvar].osver forKey:PRO_PARAM_OSVER];
    [dict setObject:[QLglobalvar shareglobalvar].appname forKey:PRO_PARAM_APPNAME];
    [dict setObject:[QLglobalvar shareglobalvar].appver forKey:PRO_PARAM_APPVER];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:PRO_PARAM_UDID];
    [dict setObject:[QLglobalvar shareglobalvar].signkey forKey:PRO_PARAM_SIGN];
}
+ (void)token_base_info:(protocol_base_info*)info jsondict:(NSDictionary *)jsondict {
    info.IsSuccess = [[jsondict valueForKey:@"IsSuccess"]boolValue];
    id errcode = jsondict[@"ErrorCode"];
    info.ErrorCode = [errcode isEqual:[NSNull null]] ? nil : errcode;
    id mess = jsondict[@"Message"];
    info.Message = [mess isEqual:[NSNull null]] ? nil : mess;
}
@end

@implementation protocol_nickname_info

@end

@implementation zyprotocol_nickname

// getnickname

+(NSString*)nickname_url {
    return [NSString stringWithFormat:@"%@/api/User/GetNickName", PRO_HOST_URL];
}

+(NSDictionary*)nickname_parame {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:8];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"clientid"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_nickname_info*)token_response:(NSDictionary *)jsondict {
    protocol_nickname_info* info = [[protocol_nickname_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    id dd = [jsondict objectForKey:@"Data"];
    NSDictionary* datadict = [dd isEqual:[NSNull null]] ? nil : dd;
    if (datadict) {
        info.NickName = datadict[@"NickName"];
        info.ClientID = datadict[@"ClientID"];
    }
    return info;
}

@end

// sendaudio

@implementation protocol_sendaudio_info

@end

@implementation zyprotocol_sendaudio

+(NSString*)sendaudio_url {
    return [NSString stringWithFormat:@"%@/api/Audio/UploadAudio", PRO_HOST_URL];
}

+(NSDictionary*)sendaudio_parame:(NSData*)audiodata audiolen:(NSInteger)audiolen towhere:(NSInteger)towhere otherid:(NSString*)otherid {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:15];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"ClientID"];
    [dict setObject:[QLcryptotool base64EncodeWithData:audiodata] forKey:@"AudioData"];
    [dict setObject:[NSNumber numberWithInteger:audiolen] forKey:@"AudioDuration"];
    [dict setObject:(otherid?otherid:@"") forKey:@"ObjectID"];
    [dict setObject:[NSNumber numberWithInteger:towhere] forKey:@"ToWhere"];
    [dict setObject:@".aac" forKey:@"Extension"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_sendaudio_info*)token_response:(NSDictionary*)jsondict {
    protocol_sendaudio_info* info = [[protocol_sendaudio_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    return info;
}

@end

@implementation protocol_audio_info

@end

@implementation protocol_tianya_audio_info

@end

@implementation zyprotocol_tianya_audio

+(NSString*)tianya_url {
    return [NSString stringWithFormat:@"%@/api/Audio/GetTopAudioList", PRO_HOST_URL];
}

+(NSDictionary*)tianya_param:(NSInteger)topnum {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:8];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"clientid"];
    [dict setObject:[NSNumber numberWithInteger:topnum] forKey:@"TopNum"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_tianya_audio_info*)token_response:(NSDictionary*)jsondict {
    protocol_tianya_audio_info* info = [[protocol_tianya_audio_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    id dd = [jsondict objectForKey:@"Data"];
    NSArray* audiolist = [dd isEqual:[NSNull null]] ? nil : dd;
    if (audiolist) {
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:20];
        for (int i=0; i<[audiolist count]; i++) {
            NSDictionary* dt = audiolist[i];
            if (dt) {
                protocol_audio_info* ai = [[protocol_audio_info alloc]init];
                ai.audioduration = [dt[@"AudioDuration"]integerValue];
                ai.audioid = dt[@"ID"];
                ai.audiourl = dt[@"AudioPath"];
                ai.createtime = dt[@"CreationTime"];
                ai.otherid = dt[@"ObjectID"];
                ai.supportcount = [dt[@"SupportCount"]integerValue];
                ai.stampcount = [dt[@"StampCount"]integerValue];
                ai.towhere = [dt[@"ToWhere"]integerValue];
                ai.clientid = dt[@"UserID"];
                ai.nickname = dt[@"NickName"];
                [arr addObject:ai];
            }
        }
        info.audio_info_list = [[NSArray alloc]initWithArray:arr];
    }
    return info;
}

@end

@implementation protocol_audio_support_info

@end

@implementation zyprotocol_audio_support

+(NSString*)support_url {
    return [NSString stringWithFormat:@"%@/api/Audio/DoSupport", PRO_HOST_URL];
}

+(NSDictionary*)support_param:(NSArray*)supportaudioids {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"clientid"];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"UserID"];
    [dict setObject:supportaudioids forKey:@"AudioIDList"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_audio_support_info*)token_response:(NSDictionary*)jsondict {
    protocol_audio_support_info* info = [[protocol_audio_support_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    return info;
}

@end

@implementation protocol_audio_diss_support_info

@end

@implementation zyprotocol_audio_diss_support

+(NSString*)diss_support_url {
    return [NSString stringWithFormat:@"%@/api/Audio/DoCancelSupport", PRO_HOST_URL];
}

+(NSDictionary*)diss_support_param:(NSArray*)diss_supportaudioids {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"clientid"];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"UserID"];
    [dict setObject:diss_supportaudioids forKey:@"AudioIDList"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_audio_diss_support_info*)token_response:(NSDictionary*)jsondict {
    protocol_audio_diss_support_info* info = [[protocol_audio_diss_support_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    return info;
}

@end

@implementation protocol_ranklist_audio_info

@end

@implementation zyprotocol_ranklist_audio

+(NSString*)ranklist_url {
    return [NSString stringWithFormat:@"%@/api/Audio/GetHotAudioList", PRO_HOST_URL];
}

+(NSDictionary*)ranklist_param:(NSInteger)topnum Period:(NSInteger)period {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"clientid"];
    [dict setObject:[NSNumber numberWithInteger:topnum] forKey:@"TopNum"];
    [dict setObject:[NSNumber numberWithInteger:period] forKey:@"Period"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_ranklist_audio_info*)token_response:(NSDictionary*)jsondict {
    protocol_ranklist_audio_info* info = [[protocol_ranklist_audio_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    id dd = [jsondict objectForKey:@"Data"];
    NSArray* audiolist = [dd isEqual:[NSNull null]] ? nil : dd;
    if (audiolist) {
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:20];
        for (int i=0; i<[audiolist count]; i++) {
            NSDictionary* dt = audiolist[i];
            if (dt) {
                protocol_audio_info* ai = [[protocol_audio_info alloc]init];
                ai.audioduration = [dt[@"AudioDuration"]integerValue];
                ai.audioid = dt[@"ID"];
                ai.audiourl = dt[@"AudioPath"];
                ai.createtime = dt[@"CreationTime"];
                ai.otherid = dt[@"ObjectID"];
                ai.supportcount = [dt[@"SupportCount"]integerValue];
                ai.stampcount = [dt[@"StampCount"]integerValue];
                ai.towhere = [dt[@"ToWhere"]integerValue];
                ai.clientid = dt[@"UserID"];
                ai.nickname = dt[@"NickName"];
                [arr addObject:ai];
            }
        }
        info.audio_info_list = [[NSArray alloc]initWithArray:arr];
    }
    return info;
}

@end

@implementation protocol_isend_audio_info

@end

@implementation zyprotocol_isend_audio

+(NSString*)isend_url {
    return [NSString stringWithFormat:@"%@/api/Audio/GetTopAudioListByUserID", PRO_HOST_URL];
}

+(NSDictionary*)isend_param:(NSInteger)topnum {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"UserID"];
    [dict setObject:[NSNumber numberWithInteger:topnum] forKey:@"TopNum"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_isend_audio_info*)token_response:(NSDictionary*)jsondict {
    protocol_isend_audio_info* info = [[protocol_isend_audio_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    id dd = [jsondict objectForKey:@"Data"];
    NSArray* audiolist = [dd isEqual:[NSNull null]] ? nil : dd;
    if (audiolist) {
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:20];
        for (int i=0; i<[audiolist count]; i++) {
            NSDictionary* dt = audiolist[i];
            if (dt) {
                protocol_audio_info* ai = [[protocol_audio_info alloc]init];
                ai.audioduration = [dt[@"AudioDuration"]integerValue];
                ai.audioid = dt[@"ID"];
                ai.audiourl = dt[@"AudioPath"];
                ai.createtime = dt[@"CreationTime"];
                ai.otherid = dt[@"ObjectID"];
                ai.supportcount = [dt[@"SupportCount"]integerValue];
                ai.stampcount = [dt[@"StampCount"]integerValue];
                ai.towhere = [dt[@"ToWhere"]integerValue];
                ai.clientid = dt[@"UserID"];
                ai.nickname = dt[@"NickName"];
                [arr addObject:ai];
            }
        }
        info.audio_info_list = [[NSArray alloc]initWithArray:arr];
    }
    return info;
}

@end

@implementation protocol_sendme_audio_info

@end

@implementation zyprotocol_sendme_audio

+(NSString*)sendme_url {
    return [NSString stringWithFormat:@"%@/api/Audio/GetTopAudioListByObjectID", PRO_HOST_URL];
}

+(NSDictionary*)sendme_param:(NSInteger)topnum {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"ObjectID"];
    [dict setObject:[NSNumber numberWithInteger:topnum] forKey:@"TopNum"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_sendme_audio_info*)token_response:(NSDictionary*)jsondict {
    protocol_sendme_audio_info* info = [[protocol_sendme_audio_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    id dd = [jsondict objectForKey:@"Data"];
    NSArray* audiolist = [dd isEqual:[NSNull null]] ? nil : dd;
    if (audiolist) {
        NSMutableArray* arr = [[NSMutableArray alloc]initWithCapacity:20];
        for (int i=0; i<[audiolist count]; i++) {
            NSDictionary* dt = audiolist[i];
            if (dt) {
                protocol_audio_info* ai = [[protocol_audio_info alloc]init];
                ai.audioduration = [dt[@"AudioDuration"]integerValue];
                ai.audioid = dt[@"ID"];
                ai.audiourl = dt[@"AudioPath"];
                ai.createtime = dt[@"CreationTime"];
                ai.otherid = dt[@"ObjectID"];
                ai.supportcount = [dt[@"SupportCount"]integerValue];
                ai.stampcount = [dt[@"StampCount"]integerValue];
                ai.towhere = [dt[@"ToWhere"]integerValue];
                ai.clientid = dt[@"UserID"];
                ai.nickname = dt[@"NickName"];
                [arr addObject:ai];
            }
        }
        info.audio_info_list = [[NSArray alloc]initWithArray:arr];
    }
    return info;
}

@end


@implementation protocol_complaint_info

@end

@implementation zyprotocol_complaint

+(NSString*)complaint_url {
    return [NSString stringWithFormat:@"%@/api/Audio/TipOff", PRO_HOST_URL];
}

+(NSDictionary*)complaint_param:(NSString*)audioid complainttype:(NSInteger)type reason:(NSString*)reason {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"UserID"];
    [dict setObject:audioid forKey:@"AudioID"];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"Type"];
    [dict setObject:reason forKey:@"Reason"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_complaint_info*)token_response:(NSDictionary*)jsondict {
    protocol_complaint_info* info = [[protocol_complaint_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    return info;
}

@end


@implementation protocol_pushblack_info

@end

@implementation zyprotocol_pushblack

+(NSString*)pushblack_url {
    return [NSString stringWithFormat:@"%@/api/User/BlockUser", PRO_HOST_URL];
}

+(NSDictionary*)pushblack_param:(NSString*)userid {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:10];
    [dict setObject:[QLglobalvar shareglobalvar].clientID forKey:@"UserID"];
    [dict setObject:userid forKey:@"BlockUserID"];
    [self setbaseparameter:dict];
    return dict;
}

+(protocol_pushblack_info*)token_response:(NSDictionary*)jsondict {
    protocol_pushblack_info* info = [[protocol_pushblack_info alloc]init];
    [self token_base_info:info jsondict:jsondict];
    return info;
}

@end
