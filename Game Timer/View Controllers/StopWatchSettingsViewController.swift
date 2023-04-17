//
//  StopWatchSettingsViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/17/23.
//

import UIKit

class StopWatchSettingsViewController: UIViewController {
    
    var fromViewController: StopWatchViewController = StopWatchViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: Variables/Constants
    // -- Simple Variables/Constants --
    // Variables/Constants that ARE NOT computed
    
    // TODO: Do not reset lap_buttonColor
    var lap1ButtonColor: UIColor = .tintColor
    var lap2ButtonColor: UIColor = .tintColor
    var lap3ButtonColor: UIColor = .tintColor
    var lap4ButtonColor: UIColor = .tintColor
    var lap1Name: String = "Lap 1"
    var lap2Name: String = "Lap 2"
    var lap3Name: String = "Lap 3"
    var lap4Name: String = "Lap 4"
    
    // MARK: Outlets
    // These outlets are used on the stop-watch-settings screen.
    @IBOutlet weak var settingsLabel: UILabel!
    
    /// A text field for a user to change the label and name of a ``Lap`` represented by ``lap1Button``.
    ///
    /// The lap's name will also be visable on ``lapTableView`` when a user creates a Lap.
    @IBOutlet weak var lap1TextField: UITextField!
    /// A text field for a user to change the label and name of a ``Lap`` represented by ``lap2Button``.
    ///
    /// The lap's name will also be visable on ``lapTableView`` when a user creates a Lap.
    @IBOutlet weak var lap2TextField: UITextField!
    /// A text field for a user to change the label and name of a ``Lap`` represented by ``lap3Button``.
    ///
    /// The lap's name will also be visable on ``lapTableView`` when a user creates a Lap.
    @IBOutlet weak var lap3TextField: UITextField!
    /// A text field for a user to change the label and name of a ``Lap`` represented by ``lap4Button``.
    ///
    /// The lap's name will also be visable on ``lapTableView`` when a user creates a Lap.
    @IBOutlet weak var lap4TextField: UITextField!
    
    
    /// A color picker for the user to change the color of ``Lap``s shown in a ``lapTableView``.
    ///
    /// The color chosen will also change ``lap1Button``'s color to match.
    @IBOutlet weak var lap1ColorWell: UIColorWell!
    /// A color picker for the user to change the color of ``Lap``s shown in a ``lapTableView``.
    ///
    /// The color chosen will also change ``lap2Button``'s color to match.
    @IBOutlet weak var lap2ColorWell: UIColorWell!
    /// A color picker for the user to change the color of ``Lap``s shown in a ``lapTableView``.
    ///
    /// The color chosen will also change ``lap3Button``'s color to match.
    @IBOutlet weak var lap3ColorWell: UIColorWell!
    /// A color picker for the user to change the color of ``Lap``s shown in a ``lapTableView``.
    ///
    /// The color chosen will also change ``lap4Button``'s color to match.
    @IBOutlet weak var lap4ColorWell: UIColorWell!
    /// The button that the user presses to set all the values they inputed.
    @IBOutlet weak var confirmButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func confirmButtonPress(_ sender: UIButton) {
        if lap1ColorWell.selectedColor != nil {
            lap1ButtonColor = (lap1ColorWell.selectedColor)!
        }
        if lap2ColorWell.selectedColor != nil {
            lap2ButtonColor = (lap2ColorWell.selectedColor)!
        }
        if lap3ColorWell.selectedColor != nil {
            lap3ButtonColor = (lap3ColorWell.selectedColor)!
        }
        if lap4ColorWell.selectedColor != nil {
            lap4ButtonColor = (lap4ColorWell.selectedColor)!
        }
        if !lap1TextField.text!.isEmpty {
            lap1Name = lap1TextField.text!
        }
        if !lap2TextField.text!.isEmpty {
            lap2Name = lap2TextField.text!
        }
        if !lap3TextField.text!.isEmpty {
            lap3Name = lap3TextField.text!
        }
        if !lap4TextField.text!.isEmpty {
            lap4Name = lap4TextField.text!
        }
        fromViewController.lap1ButtonColor = lap1ButtonColor
        fromViewController.lap2ButtonColor = lap2ButtonColor
        fromViewController.lap3ButtonColor = lap3ButtonColor
        fromViewController.lap4ButtonColor = lap4ButtonColor
        fromViewController.lap1Name = lap1Name
        fromViewController.lap2Name = lap2Name
        fromViewController.lap3Name = lap3Name
        fromViewController.lap4Name = lap4Name
        Task { await fromViewController.updateScreen() }
        dismiss(animated: true)
    }
    
    
    
    
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}

