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

#ifndef _OS_THUNKS_H__
#define _OS_THUNKS_H__

#include <stdint.h>

#ifndef _os_unlikely
#define _os_unlikely(x) OS_EXPECT(!!(x), 0)
#endif

#ifndef MIN
#define MIN(a, b)  (((a)<(b))?(a):(b))
#endif

#ifndef MAX
#define MAX(a, b)  (((a)>(b))?(a):(b))
#endif

#ifndef _OS_TRACE_INTERNAL_CRASH
#define _OS_TRACE_INTERNAL_CRASH(_ptr, _message) _os_log_reportError(0, _message)
#endif

#ifndef _os_unlikely
#define _os_unlikely(x) OS_EXPECT(!!(x), 0)
#endif

#define _os_add_overflow(a, b, res) __builtin_add_overflow((a), (b), (res))
#define _os_mul_overflow(a, b, res) __builtin_mul_overflow((a), (b), (res))

__attribute__((__visibility__("hidden")))
void
_os_log_reportError(uint32_t flags, const char *message);

#endif // _OS_THUNKS_H__
