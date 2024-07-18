//
//  MeasurementFormatter+Extensions.swift
//  NearMe
//
//  Created by Jibryll Brinkley on 7/18/24.
//

import Foundation

extension MeasurementFormatter {
    
    static var distance: MeasurementFormatter {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        formatter.locale = Locale.current
        return formatter
    }
    
    
}
