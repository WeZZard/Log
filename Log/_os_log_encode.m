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

#include "_os_log_encode.h"

#include <TargetConditionals.h>
#include <Availability.h>
#include <CoreFoundation/CoreFoundation.h>
#include <dlfcn.h>
#include <dispatch/dispatch.h>
#include <os/base.h>
#include <objc/runtime.h>
#include <wchar.h>

static inline void
_os_log_encode_arg(_os_trace_blob_t ob, _os_log_fmt_cmd_t cmd, const void *data)
{
    _os_trace_blob_add(ob, cmd, sizeof(_os_log_fmt_cmd_s));
    _os_trace_blob_add(ob, data, cmd->cmd_size);
}

bool
_os_log_encode(char buf[_OS_LOG_FMT_BUF_SIZE], const char *format, va_list args, int saved_errno, _os_trace_blob_t ob)
{
    _os_log_fmt_hdr_s hdr = { };
    _os_trace_blob_add(ob, &hdr, sizeof(hdr));
    
    const char *percent = strchr(format, '%');
    
    while (percent != NULL) {
        ++percent;
        if (percent[0] != '%') {
            _os_log_fmt_cmd_s cmd = { };
            int type = T_INT;
            bool long_double = false;
            int precision = 0;
            char ch;
            
            if (hdr.hdr_cmd_cnt == _OS_LOG_FMT_MAX_CMDS) {
                break;
            }
            
            for (bool done = false; !done; percent++) {
                switch (ch = percent[0]) {
                        /* type of types or other */
                    case 'l': type++; break; // longer
                    case 'h': type--; break; // shorter
                    case 'z': type = T_SIZE; break;
                    case 'j': type = T_INTMAX; break;
                    case 't': type = T_PTRDIFF; break;
                        
                    case '.': // precision
                        cmd.cmd_type = _OSLF_CMD_TYPE_COUNT;
                        cmd.cmd_size = sizeof(int);
                        
                        if ((percent[1]) == '*') {
                            precision = va_arg(args, int);
                            percent++;
                        } else {
                            while (isdigit(percent[1])) {
                                precision = 10 * precision + (ch - '0');
                                percent++;
                            }
                            if (precision > 1024) precision = 1024;
                        }
                        _os_log_encode_arg(ob, &cmd, &precision);
                        hdr.hdr_cmd_cnt++;
                        break;
                        
                    case '-': // left-align
                    case '+': // force sign
                    case ' ': // prefix non-negative with space
                    case '#': // alternate
                    case '\'': // group by thousands
                        break;
                        
                    case '{': // annotated symbols
                        for (const char *curr2 = percent + 1; (ch = (*curr2)) != 0; curr2++) {
                            if (ch == '}') {
                                if (strncmp(percent + 1, "private", MIN(curr2 - percent - 1, 7)) == 0) {
                                    hdr.hdr_flags |= _OSLF_HDR_FLAG_HAS_PRIVATE;
                                    cmd.cmd_flags |= _OSLF_CMD_FLAG_PRIVATE;
                                } else if (strncmp(percent + 1, "public", MIN(curr2 - percent - 1, 6)) == 0) {
                                    cmd.cmd_flags |= _OSLF_CMD_FLAG_PUBLIC;
                                }
                                percent = curr2;
                                break;
                            }
                        }
                        break;
                        
#define encode_smallint(ty) ({ \
    int __var = va_arg(args, int); \
    cmd.cmd_size = sizeof(__var); \
    _os_log_encode_arg(ob, &cmd, &__var); \
    hdr.hdr_cmd_cnt++; \
})
                        
#define encode(ty) ({ \
    ty __var = va_arg(args, ty); \
    cmd.cmd_size = sizeof(__var); \
    _os_log_encode_arg(ob, &cmd, &__var); \
    hdr.hdr_cmd_cnt++; \
})
                        
                        /* fixed types */
                    case 'c': // char
                    case 'd': // integer
                    case 'i': // integer
                    case 'o': // octal
                    case 'u': // unsigned
                    case 'x': // hex
                    case 'X': // upper-hex
                        cmd.cmd_type = _OSLF_CMD_TYPE_SCALAR;
                        switch (type) {
                            case T_CHAR: encode_smallint(char); break;
                            case T_SHORT: encode_smallint(short); break;
                            case T_INT: encode(int); break;
                            case T_LONG: encode(long); break;
                            case T_LONGLONG: encode(long long); break;
                            case T_SIZE: encode(size_t); break;
                            case T_INTMAX: encode(intmax_t); break;
                            case T_PTRDIFF: encode(ptrdiff_t); break;
                            default: return false;
                        }
                        done = true;
                        break;
                        
                    case 'P': // pointer data
                        if (precision > 0) { // only encode a pointer if we have been given a length
                            hdr.hdr_flags |= _OSLF_HDR_FLAG_HAS_NON_SCALAR;
                            cmd.cmd_type = _OSLF_CMD_TYPE_DATA;
                            cmd.cmd_size = precision;
                            void *p = va_arg(args, void *);
                            _os_log_encode_arg(ob, &cmd, p);
                            hdr.hdr_cmd_cnt++;
                            precision = 0;
                            done = true;
                        }
                        break;
                        
                    case 'L': // long double
                        long_double = true;
                        break;
                        
                    case 'a': case 'A': case 'e': case 'E': // floating types
                    case 'f': case 'F': case 'g': case 'G':
                        cmd.cmd_type = _OSLF_CMD_TYPE_SCALAR;
                        if (long_double) {
                            encode(long double);
                        } else {
                            encode(double);
                        }
                        done = true;
                        break;
                        
#if 0
                    case 'C': // wide-char
                        value.type.wch = va_arg(args, wint_t);
                        _os_log_encode_arg(&value.type.wch, sizeof(value.type.wch), OS_LOG_BUFFER_VALUE_TYPE_SCALAR, flags, context);
                        done = true;
                        break;
#endif
                        
#if 0
                        // String types get sent from Swift as NSString objects.
                    case 's': // string
                        value.type.pch = va_arg(args, char *);
                        context->buffer->flags |= OS_LOG_BUFFER_HAS_NON_SCALAR;
                        _os_log_encode_arg(&value.type.pch, sizeof(value.type.pch), OS_LOG_BUFFER_VALUE_TYPE_STRING, flags, context);
                        prec = 0;
                        done = true;
                        break;
#endif
                        
                    case '@': // CFTypeRef aka NSObject *
                        hdr.hdr_flags |= _OSLF_HDR_FLAG_HAS_NON_SCALAR;
                        cmd.cmd_type = _OSLF_CMD_TYPE_OBJECT;
                        encode(void *);
                        done = true;
                        break;
                        
                    case 'm':
                        cmd.cmd_type = _OSLF_CMD_TYPE_SCALAR;
                        cmd.cmd_size = sizeof(int);
                        _os_log_encode_arg(ob, &cmd, &saved_errno);
                        hdr.hdr_cmd_cnt++;
                        done = true;
                        break;
                        
                    default:
                        if (isdigit(ch)) { // [0-9]
                            continue;
                        }
                        done = true;
                        break;
                }
                
                if (done) {
                    percent = strchr(percent, '%'); // Find next format
                    break;
                }
            }
        } else {
            percent = strchr(percent+1, '%'); // Find next format after %%
        }
    }
    *(_os_log_fmt_hdr_t)buf = hdr;
    return true;
}

#undef encode_smallint
#undef encode
