//
//  ColorExtentions.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-23.
//

import Foundation
import SwiftUI

import SwiftUI

extension Color {
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return "#000000"
        }
        let red = components[0]
        let green = components[1]
        let blue = components[2]
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(red * 255)), lroundf(Float(green * 255)), lroundf(Float(blue * 255)))
    }
}

