//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//


#ifndef _OS_LOG_ENCODE_H__
#define _OS_LOG_ENCODE_H__

#import <Foundation/Foundation.h>

#include <stdarg.h>
#include <os/log.h>
#include "_os_trace_blob.h"

#define _OST_FORMAT_MAX_STRING_SIZE 1024
#define _OS_LOG_FMT_MAX_CMDS        48
#define _OS_LOG_FMT_BUF_SIZE        (2 + (2 + 16) * _OS_LOG_FMT_MAX_CMDS)

enum _os_trace_int_types_t {
    T_CHAR = -2,
    T_SHORT = -1,
    T_INT = 0,
    T_LONG = 1,
    T_LONGLONG = 2,
    T_SIZE = 3,
    T_INTMAX = 4,
    T_PTRDIFF = 5,
};

OS_ENUM(_os_log_fmt_cmd_flags, uint8_t,
        _OSLF_CMD_FLAG_PRIVATE = 0x1,
        _OSLF_CMD_FLAG_PUBLIC  = 0x2,
        );

OS_ENUM(_os_log_fmt_cmd_type, uint8_t,
        _OSLF_CMD_TYPE_SCALAR      = 0,
        _OSLF_CMD_TYPE_COUNT       = 1,
        _OSLF_CMD_TYPE_STRING      = 2,
        _OSLF_CMD_TYPE_DATA        = 3,
        _OSLF_CMD_TYPE_OBJECT      = 4,
        _OSLF_CMD_TYPE_WIDE_STRING = 5,
        _OSLF_CMD_TYPE_ERRNO       = 6,
        );

OS_ENUM(_os_log_fmt_hdr_flags, uint8_t,
        _OSLF_HDR_FLAG_HAS_PRIVATE    = 0x01,
        _OSLF_HDR_FLAG_HAS_NON_SCALAR = 0x02,
        );

typedef struct {
    _os_log_fmt_cmd_flags_t cmd_flags : 4;
    _os_log_fmt_cmd_type_t cmd_type : 4;
    uint8_t cmd_size;
    uint8_t cmd_data[];
} _os_log_fmt_cmd_s, * _os_log_fmt_cmd_t;

typedef struct _os_log_fmt_hdr_s {
    _os_log_fmt_hdr_flags_t hdr_flags;
    uint8_t hdr_cmd_cnt;
    uint8_t hdr_data[];
} _os_log_fmt_hdr_s, * _os_log_fmt_hdr_t;

FOUNDATION_EXPORT bool
_os_log_encode(char buf[_OS_LOG_FMT_BUF_SIZE], const char *format, va_list args, int saved_errno, _os_trace_blob_t ob);

#endif // _OS_LOG_ENCODE_H__
