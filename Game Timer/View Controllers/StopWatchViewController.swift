//
//  StopWatchViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/12/23.
//

import UIKit

class StopWatchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Outlets
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var lap1Button: UIButton!
    @IBOutlet weak var lap2Button: UIButton!
    @IBOutlet weak var lap3Button: UIButton!
    @IBOutlet weak var lap4Button: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    // MARK: View Controllers
    let stopWatchViewControllerStoryBoard: UIStoryboard = UIStoryboard(name: "StopWatch", bundle: nil)
    let stopWatchSettingsViewControllerStoryBoard: UIStoryboard = UIStoryboard(name: "StopWatchSettings", bundle: nil)
    
    
    // MARK: Settings
    @IBAction func settingsButtonPress(_ sender: UIButton) {
        let stopWatchSettingsViewController = stopWatchSettingsViewControllerStoryBoard.instantiateViewController(withIdentifier: "StopWatchSettings")
        present(stopWatchSettingsViewController, animated: true)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
