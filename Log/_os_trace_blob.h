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

#ifndef _OS_TRACE_BLOB_H__
#define _OS_TRACE_BLOB_H__

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "_os_thunks.h"

OS_ENUM(_os_trace_blob_flags, uint16_t,
    OS_TRACE_BLOB_NEEDS_FREE = 0x0001,
    OS_TRACE_BLOB_TRUNCATED  = 0x0002,
);

typedef struct _os_trace_blob_s {
    union {
        uint8_t *ob_b;
        void *ob_v;
        char *ob_s;
        const char *ob_c;
    };
    uint32_t ob_len;
    uint32_t ob_size;
    uint32_t ob_maxsize;
    uint16_t ob_flags;
    bool     ob_binary;
} _os_trace_blob_s, *_os_trace_blob_t;

#pragma mark - helpers (not to be used directly)

OS_ALWAYS_INLINE
static inline uint32_t
_os_trace_blob_available(_os_trace_blob_t ob)
{
    return ob->ob_size - !ob->ob_binary - ob->ob_len;
}

OS_ALWAYS_INLINE
static inline uint32_t
_os_trace_blob_growlen(_os_trace_blob_t ob, size_t extra)
{
    ob->ob_len += extra;
    if (!ob->ob_binary) ob->ob_s[ob->ob_len] = '\0';
    return (uint32_t)extra;
}

OS_ALWAYS_INLINE
static inline void
_os_trace_blob_setlen(_os_trace_blob_t ob, uint32_t len)
{
    ob->ob_len = len;
    if (!ob->ob_binary) ob->ob_s[len] = '\0';
}

__attribute__((__visibility__("hidden")))
void
_os_trace_blob_destroy_slow(_os_trace_blob_t ob);

#pragma mark - initialization and simple helpers

#define _os_trace_blob_init_buf(buf, binary) (_os_trace_blob_s){ \
        .ob_v = buf, \
        .ob_binary = binary, \
        .ob_size = ({ _Static_assert(sizeof(*buf) == 1, ""); countof(buf); }) \
    }

OS_ALWAYS_INLINE
static inline uint32_t
_os_trace_blob_max_available(_os_trace_blob_t ob)
{
    uint32_t used = ob->ob_len + !ob->ob_binary;
    if (ob->ob_maxsize) return ob->ob_maxsize - used;
    if (ob->ob_size) return ob->ob_size - used;
    return 0;
}

OS_ALWAYS_INLINE
static inline size_t
_os_trace_blob_is_empty(_os_trace_blob_t ob)
{
    return ob->ob_len == 0;
}

OS_MALLOC __attribute__((__visibility__("hidden")))
char *
_os_trace_blob_detach(_os_trace_blob_t ob, size_t *len);

OS_ALWAYS_INLINE
static inline void
_os_trace_blob_assert_not_allocated(_os_trace_blob_t ob)
{
    if (_os_unlikely(ob->ob_flags & OS_TRACE_BLOB_NEEDS_FREE)) {
        _OS_TRACE_INTERNAL_CRASH(0, "Buffer needs free");
    }
}

OS_ALWAYS_INLINE
static inline void
_os_trace_blob_destroy(_os_trace_blob_t ob)
{
    if (ob->ob_flags & OS_TRACE_BLOB_NEEDS_FREE) {
        return _os_trace_blob_destroy_slow(ob);
    }
}

OS_ALWAYS_INLINE
static inline void
_os_trace_blob_set_string(_os_trace_blob_t ob, const char *s)
{
    if (ob->ob_flags & OS_TRACE_BLOB_NEEDS_FREE) {
        free(ob->ob_s);
    }
    *ob = (_os_trace_blob_s){
        .ob_c = s,
        .ob_len = (uint32_t)strlen(s),
        // not setting the size means "const"
    };
}

OS_ALWAYS_INLINE
static inline void
_os_trace_blob_rtrim(_os_trace_blob_t ob)
{
    uint32_t len = ob->ob_len;
    while (len > 0 && isspace(ob->ob_s[len - 1])) len--;
    _os_trace_blob_setlen(ob, len);
}

#pragma mark - appending to the blob

__attribute__((__visibility__("hidden")))
uint32_t
_os_trace_blob_add_slow(_os_trace_blob_t ob, const void *ptr, size_t size);

OS_ALWAYS_INLINE
static inline uint32_t
_os_trace_blob_add(_os_trace_blob_t ob, const void *ptr, size_t size)
{
    if (_os_unlikely(ob->ob_flags & OS_TRACE_BLOB_TRUNCATED)) {
        return 0;
    }
    if (_os_unlikely(size > _os_trace_blob_available(ob))) {
        return _os_trace_blob_add_slow(ob, ptr, size);
    }
    memcpy(ob->ob_s + ob->ob_len, ptr, size);
    return _os_trace_blob_growlen(ob, size);
}

OS_ALWAYS_INLINE
static inline uint32_t
_os_trace_blob_addc(_os_trace_blob_t ob, int c)
{
    uint8_t byte = (uint8_t)c;
    return _os_trace_blob_add(ob, &byte, 1);
}

OS_ALWAYS_INLINE
static inline uint32_t
_os_trace_blob_add_safe_string(_os_trace_blob_t ob, const char *s)
{
    // safe means pure ascii no control chars
    return _os_trace_blob_add(ob, s, strlen(s));
}

#endif // !_OS_TRACE_BLOB_H__
