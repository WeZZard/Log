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

#include "_os_thunks.h"
#import <Foundation/NSException.h>

extern void
_os_log_reportError(uint32_t flags, const char *message) {
    [NSException raise: NSInternalInconsistencyException
                format: @"OSTrace internal error. Flags: \"%ul\" Message: \"%s\"", flags, message];
}
