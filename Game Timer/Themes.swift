//
//  Themes.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/13/23.
//

import Foundation
import UIKit

struct Theme {
    static var selectedTheme: Theme = Theme(customLabelColor: .label, customPrimaryColor: .tintColor, customBackgroundColor: .black)
    /// The color set manually or by a color picker.
    ///
    /// Used throughout the app to give a custom color for labels
    var customLabelColor: UIColor
    /// The color set manually or by a color picker.
    ///
    /// Used throughout the app to give a custom color for buttons and
    var customPrimaryColor: UIColor
    var customSecondaryColor: UIColor {
        return UIColor( ciColor: CIColor(
            red: CIColor(color: customPrimaryColor).red,
            green: CIColor(color: customPrimaryColor).green,
            blue: CIColor(color: customPrimaryColor).blue,
            alpha: CIColor(color: customPrimaryColor).alpha/2
        ))
    }
    var customBackgroundColor: UIColor
}
