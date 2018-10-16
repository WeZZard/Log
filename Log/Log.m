//
//  Log.m
//  Log
//
//  Created on 24/2/2018.
//

#import <Log/Log.h>
#import "_os_log_encode.h"

#ifdef USES_UNDOCUMENTED_OS_LOG_PACK_API
#include "_os_log_pack.h"
#endif

void LGLogvImpl(
    const void * dso,
    const void * retaddr,
    os_log_t oslog,
    os_log_type_t type,
    const char * format,
    va_list args
    )
{
    int saved_errno = errno; // %m
    char buf[_OS_LOG_FMT_BUF_SIZE];
    _os_trace_blob_s ob = {
        .ob_s = buf,
        .ob_size = _OS_LOG_FMT_BUF_SIZE,
        .ob_binary = true
    };
    
    if (_os_log_encode(buf, format, args, saved_errno, &ob)) {
#ifdef USES_UNDOCUMENTED_OS_LOG_PACK_API
        // Use `os_log_pack_send` where available.
        if (os_log_pack_send) {
            size_t sz = _os_log_pack_size(ob.ob_len);
            union {
                os_log_pack_s pack;
                uint8_t buf[_OS_LOG_FMT_BUF_SIZE + sizeof(os_log_pack_s)];
            } u;
            // `_os_log_encode` has already packed `saved_errno` into
            // an `_OSLF_CMD_TYPE_SCALAR` command as the
            // `_OSLF_CMD_TYPE_ERRNO` does not deploy backwards, so passes
            // zero for errno here.
            uint8_t *ptr = _os_log_pack_fill(&u.pack, sz, 0, dso, format);
            u.pack.olp_pc = retaddr;
            memcpy(ptr, buf, ob.ob_len);
            os_log_pack_send(&u.pack, oslog, type);
        } else {
#endif
            _os_log_impl(
                (void *)dso,
                oslog,
                type,
                format,
                (uint8_t *)buf, ob.ob_len
            );
#ifdef USES_UNDOCUMENTED_OS_LOG_PACK_API
        }
#endif
    }
}

void * LGReturnAddress(void) {
    return __builtin_return_address(1);
}
