//
//  PresetBehavior.swift
//  Log
//
//  Created on 16/10/2018.
//


/// Preset behavior of logging.
///
@available(macOSApplicationExtension 10.12, *)
@available(iOSApplicationExtension 10.0, *)
@available(tvOSApplicationExtension 10.0, *)
@available(watchOSApplicationExtension 3.0, *)
public enum LogPresetBehavior {
    /// The shared default log.
    case `default`
    /// The shared disabled log.
    case disabled
}
