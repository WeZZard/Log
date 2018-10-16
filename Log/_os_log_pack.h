//
//  _os_log_pack.h
//  Log
//
//  Created on 16/10/2018.
//


#ifndef _OS_LOG_PACK_H__
#define _OS_LOG_PACK_H__

#ifdef USES_UNDOCUMENTED_OS_LOG_PACK_API
typedef struct os_log_pack_s {
    uint64_t        olp_continuous_time;
    struct timespec olp_wall_time;
    const void     *olp_mh;
    const void     *olp_pc;
    const char     *olp_format;
    uint8_t         olp_data[0];
} os_log_pack_s, *os_log_pack_t;

API_AVAILABLE(macosx(10.12.4), ios(10.3), tvos(10.2), watchos(3.2))
OS_EXPORT size_t
_os_log_pack_size(size_t os_log_format_buffer_size);

API_AVAILABLE(macosx(10.12.4), ios(10.3), tvos(10.2), watchos(3.2))
OS_EXPORT uint8_t *
_os_log_pack_fill(os_log_pack_t pack, size_t size, int saved_errno, const void *dso, const char *fmt);

API_AVAILABLE(macosx(10.12.4), ios(10.3), tvos(10.2), watchos(3.2))
OS_EXPORT void
os_log_pack_send(os_log_pack_t pack, os_log_t log, os_log_type_t type);
#endif

#endif // _OS_LOG_PACK_H__
