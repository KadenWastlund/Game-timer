//
//  SettingsViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/17/23.
//

import UIKit
import Foundation

/// This view controller is used on the settings tab.
class SettingsViewController: UIViewController {
    // MARK: Misc Functions
    // These functions don't have any catagroizable function, but they are needed none the less.
    
    override func viewWillAppear(_ animated: Bool) {
        
        // TODO: Set everything to change on appear.
    }
    
    /// When the view is first loaded.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // <#Misc Functions go here#>
    
    // MARK: Outlets
    // These are for every object on the view controller.
    
    /// The main view of the View Controller.
    @IBOutlet var settingsView: UIView!
    
    /// A label that simply says "Primary Color:"
    @IBOutlet weak var primaryColorLabel: UILabel!
    /// A label that simply says "Seconday Color:"
    @IBOutlet weak var secondaryColorLabel: UILabel!
    /// A label that simply says "Background Color:"
    @IBOutlet weak var backgroundColorLabel: UILabel!
    
    /// A ColorWell that the user can interact with to change the
    @IBOutlet weak var primaryColorWell: UIColorWell!
    @IBOutlet weak var secondaryColorWell: UIColorWell!
    @IBOutlet weak var backgroundColorWell: UIColorWell!
    
    /// A button that sets all the values on the ``SettingsViewController`` so it effects the entire application.
    @IBOutlet weak var setButtonOutlet: UIButton!
    
    
    // MARK: Actions
    // These are for when an action is done on an object.
    
    @IBAction func setButtonTouch(_ sender: UIButton) {
        // MARK: Timer Screen
    }
    
    
    // MARK: Functions
    // Functions used throughout the view controller.
    
    // <#Functions go here#>
    
    // MARK: Segue
    /// Creates a pass for sending values into another ViewController while moving to that ViewController.
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if let vc = segue.destination as? <#resultingViewController#> {
    //            vc.fromViewController = self // Sets a value(which should be made at the resultingViewController) so that you can pass values back without needing to segue.
    //            vc.<#resultingViewController Variable#> = <#fromViewController Variable#>
    //        }
    //    }
}
