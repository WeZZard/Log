[![Build Status](https://travis-ci.com/WeZZard/Log.svg?branch=master)](https://travis-ci.com/WeZZard/Log)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

[中文](./使用說明.md)

Offers an informative and modern logging interface for Swift.

Apple introduced [unified logging system] at WWDC 2016. Since it is a set
of C API which is very difficult to use in Swift, it was not spreaded out
as other famous frameworks authored by Apple. I just have encapusulated it
in Swift with some modern Swift practice and I think people can easily
make use of this framework in Swift now.

## Features

- [x] Esay access to subsystem, category, log type and preset behavior.

- [x] Supports Objective-C style formatted string.

- [x] Be able to log very long messages.

- [x] Struct extension support for extending subsystem.

- [x] Struct extension support for extending category.

## Usages

### The Simplest Log

```swift
import Log

Log.log("An %@ style formatted string.", "Objective-C")
```

### Logging with Conditions

```swift
import Log

// Log debug.
Log.log(type: .debug, "A debug log.")

// Log info.
Log.log(type: .info, "A info log.")

// Log error.
Log.log(type: .error, "An error log.")

// Log fault.
Log.log(type: .fault, "A fault log.")
```

### Logging with Preset Behavior

```swift
import Log

// Log with default behavior.
Log.log(presetBehavior: .default, "A log with default behavior.")

// or you can just write:
Log.log("A log with default behavior.")

// Log with disabled behavior.
Log.log(presetBehavior: .disabled, "A log with disabled behavior.")
```

### Enriching Log Info with a Very Little Work

Adding subsystem info.

```swift
import Log

extension Log.Subsystem {
    static let mySubsystem = "com.WeZZard.MySubsystem"
}

Log.log(subsystem: .mySubsystem, "A log.")
```

Adding category info.

```swift
import Log

extension Log.Category {
    static let category = "com.WeZZard.MySubsystem.MyCategory"
}

Log.log(category: .myCategory, "A log.")
```

Adding class info (this is useful for debugging class functions).

```swift
import Log

class Foo {
    class func bar() {
        Log.log(class: self, "A log.")
    }
}
```

Adding object info (this is useful for debugging instance functions).

```swift
import Log

class Foo {
    func bar() {
        Log.log(object: self, "A log.")
    }
}
```

### Use Undocumented API

By setting `-D USES_UNDOCUMENTED_OS_LOG_PACK_API` in Other Swift Flags in
Xcode's Building Settings, you can make the framework to use undocumented
API to log. This is disabled by default.

## License

MIT

[unified logging system]: https://developer.apple.com/videos/play/wwdc2016/721/
