//
//  Log.h
//  Log
//
//  Created on 24/2/2018.
//

#import <Foundation/Foundation.h>
#import <os/log.h>

//! Project version number for Log_iOS.
FOUNDATION_EXPORT double LogVersionNumber;

//! Project version string for Log_iOS.
FOUNDATION_EXPORT const unsigned char LogVersionString[];


/// Implementation of variant length argument logger.
///
API_AVAILABLE(macosx(10.12), ios(10.0), tvos(10.0), watchos(3.0))
__attribute__((visibility("hidden")))
FOUNDATION_EXTERN void LGLogvImpl(
    const void * _Nullable dso,
    const void * _Nonnull retaddr,
    os_log_t _Nonnull oslog,
    os_log_type_t type,
    const char * _Nonnull format,
    va_list args
) NS_REFINED_FOR_SWIFT;


/// Gets the next next function call's return address on the stack.
///
API_AVAILABLE(macosx(10.12), ios(10.0), tvos(10.0), watchos(3.0))
__attribute__((visibility("hidden")))
FOUNDATION_EXTERN void * _Nonnull LGReturnAddress(void) NS_REFINED_FOR_SWIFT;
