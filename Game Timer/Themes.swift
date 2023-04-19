//
//  Themes.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/13/23.
//

import Foundation
import UIKit

class ThemeDefault {
    static let defaults = UserDefaults.standard

    static var defaultPrimaryColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static var savedPrimaryString: [String: CGFloat?] {
        [
            "Red":   ThemeDefault.defaultPrimaryColor.cgColor.components?[0],
            "Green": ThemeDefault.defaultPrimaryColor.cgColor.components?[1],
            "Blue":  ThemeDefault.defaultPrimaryColor.cgColor.components?[2],
            "Alpha": ThemeDefault.defaultPrimaryColor.cgColor.components?[3]
        ]
    }

    static var defaultBackgroundColor: UIColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static var savedBackgroundString: [String: CGFloat?] {
        [
            "Red":   ThemeDefault.defaultBackgroundColor.cgColor.components?[0],
            "Green": ThemeDefault.defaultBackgroundColor.cgColor.components?[1],
            "Blue":  ThemeDefault.defaultBackgroundColor.cgColor.components?[2],
            "Alpha": ThemeDefault.defaultBackgroundColor.cgColor.components?[3]
        ]
    }

    init() {
        let primaryRed = ThemeDefault.savedPrimaryString["Red"] ?? 0.0
        let primaryGreen = ThemeDefault.savedPrimaryString["Green"] ?? 0.0
        let primaryBlue = ThemeDefault.savedPrimaryString["Blue"] ?? 0.0
        let primaryAlpha = ThemeDefault.savedPrimaryString["Alpha"] ?? 0.0
        ThemeDefault.defaultPrimaryColor = UIColor(red: primaryRed, green: primaryGreen, blue: primaryBlue, alpha: primaryAlpha)

        let backgroundRed = ThemeDefault.savedBackgroundString["Red"] ?? 0.0
        let backgroundGreen = ThemeDefault.savedBackgroundString["Green"] ?? 0.0
        let backgroundBlue = ThemeDefault.savedBackgroundString["Blue"] ?? 0.0
        let backgroundAlpha = ThemeDefault.savedBackgroundString["Alpha"] ?? 0.0
        ThemeDefault.defaultBackgroundColor = UIColor(red: backgroundRed, green: backgroundGreen, blue: backgroundBlue, alpha: backgroundAlpha)
    }

    static func saveColors() {
        let savedPrimaryString: [String: CGFloat?] = [
            "Red":   ThemeDefault.defaultPrimaryColor.cgColor.components?[0],
            "Green": ThemeDefault.defaultPrimaryColor.cgColor.components?[1],
            "Blue":  ThemeDefault.defaultPrimaryColor.cgColor.components?[2],
            "Alpha": ThemeDefault.defaultPrimaryColor.cgColor.components?[3]
        ]
        ThemeDefault.defaults.set(savedPrimaryString, forKey: "defaultPrimary")

        let savedBackgroundString: [String: CGFloat?] = [
            "Red":   ThemeDefault.defaultBackgroundColor.cgColor.components?[0],
            "Green": ThemeDefault.defaultBackgroundColor.cgColor.components?[1],
            "Blue":  ThemeDefault.defaultBackgroundColor.cgColor.components?[2],
            "Alpha": ThemeDefault.defaultBackgroundColor.cgColor.components?[3]
        ]
        ThemeDefault.defaults.set(savedBackgroundString, forKey: "defaultBackground")
    }
}


struct Theme {
    static var selectedTheme: Theme = Theme(customPrimaryColor: ThemeDefault.defaultPrimaryColor, customBackgroundColor: ThemeDefault.defaultBackgroundColor)
    
    /// The color set manually or by a color picker.
    ///
    /// Used throughout the app to give a custom color for buttons and
    var customPrimaryColor: UIColor
    var customSecondaryColor: UIColor {
        return UIColor( ciColor: CIColor(
            red: CIColor(color: customPrimaryColor).red,
            green: CIColor(color: customPrimaryColor).green,
            blue: CIColor(color: customPrimaryColor).blue,
            alpha: CIColor(color: customPrimaryColor).alpha/CGFloat(Constants.secondaryAlphaChange)
        ))
    }
    var customBackgroundColor: UIColor
    
    
}


