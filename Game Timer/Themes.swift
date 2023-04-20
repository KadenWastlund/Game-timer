//
//  Themes.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/13/23.
//

import Foundation
import UIKit

class ThemeDefault {
    
    var backgroundColorHexString: String {
        get {
            if let hexValue = UserDefaults.standard.value(forKey: Constants.defaultBackgroundKey) as? String {
                return hexValue
            }
            return "FFFFFF"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.defaultBackgroundKey)
        }
    }
    
    var primaryColorHexString: String {
        get {
            if let hexValue = UserDefaults.standard.value(forKey: Constants.defaultPrimaryKey) as? String {
                return hexValue
            }
            return "FFFFFF"
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Constants.defaultPrimaryKey)
        }
    }
    
    private static let sharedSettings = ThemeDefault() // lazy singleton
    
    class func shared() -> ThemeDefault {
        return sharedSettings
    }
    
    static func hexStringToUIColor(hexString: String) -> UIColor? {
        // Remove any leading '#' character
        var cleanedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanedHexString = cleanedHexString.replacingOccurrences(of: "#", with: "")
        
        // Check if the cleaned string has a valid length
        guard cleanedHexString.count == 6 || cleanedHexString.count == 8 else {
            return nil // Invalid hexadecimal string
        }
        
        // Convert the hexadecimal string to an unsigned integer
        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHexString).scanHexInt64(&rgbValue)
        
        // Extract the individual RGB components
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = cleanedHexString.count == 8 ? CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0 : 1.0
        
        // Create and return the UIColor object
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func hexString(from color: UIColor) -> String {
        guard let components = color.cgColor.components else { return "#FFFFFFF" }
        
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)

        return String(format: "#%02X%02X%02X", red, green, blue)
    }
}


struct Theme {
    static var selectedTheme: Theme = Theme(
        customPrimaryColor: ThemeDefault.hexStringToUIColor(hexString: ThemeDefault.shared().primaryColorHexString) ?? .tintColor,
        customBackgroundColor: ThemeDefault.hexStringToUIColor(hexString: ThemeDefault.shared().backgroundColorHexString) ?? .black)
                                                
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
                                            
                                            
