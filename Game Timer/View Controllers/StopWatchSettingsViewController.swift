//
//  StopWatchSettingsViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/17/23.
//

import UIKit

class StopWatchSettingsViewController: UIViewController {
    
    var fromViewController: StopWatchViewController = StopWatchViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        stopwatchSettingsView.backgroundColor = Theme.selectedTheme.customBackgroundColor
        confirmButton.tintColor = Theme.selectedTheme.customPrimaryColor
        lap1TextField.backgroundColor = Theme.selectedTheme.customSecondaryColor
        lap2TextField.backgroundColor = Theme.selectedTheme.customSecondaryColor
        lap3TextField.backgroundColor = Theme.selectedTheme.customSecondaryColor
        lap4TextField.backgroundColor = Theme.selectedTheme.customSecondaryColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fills the colorWells.selectedColor to the previous color so that the user has a referance point.
        lap1ColorWell.selectedColor = lap1ButtonColor
        lap2ColorWell.selectedColor = lap2ButtonColor
        lap3ColorWell.selectedColor = lap3ButtonColor
        lap4ColorWell.selectedColor = lap4ButtonColor
        // Fills the textField.text to the previous names so that the user has a referance point.
        lap1TextField.text = lap1Name
        lap2TextField.text = lap2Name
        lap3TextField.text = lap3Name
        lap4TextField.text = lap4Name
    }
    
    // MARK: Variables/Constants
    // -- Simple Variables/Constants --
    // Variables/Constants that ARE NOT computed
    
    
    var lap1ButtonColor: UIColor = UIColor()
    var lap2ButtonColor: UIColor = UIColor()
    var lap3ButtonColor: UIColor = UIColor()
    var lap4ButtonColor: UIColor = UIColor()
    var lap1Name: String =          String()
    var lap2Name: String =          String()
    var lap3Name: String =          String()
    var lap4Name: String =          String()
    
    // MARK: Outlets
    // These outlets are used on the stop-watch-settings screen.
    
    /// The main view of the View Controller.
    @IBOutlet var stopwatchSettingsView: UIView!
    
    
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
        // If the lap_colorWell isn't nil, set the lap_ButtonColor to the colorWell's value.
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
        // If the lap_TextField.text is !empty, set the lap_Name to the textField's text.
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
        // Sets the lap_ButtonColor to the inputed color.
        fromViewController.lap1Color = lap1ButtonColor
        fromViewController.lap2Color = lap2ButtonColor
        fromViewController.lap3Color = lap3ButtonColor
        fromViewController.lap4Color = lap4ButtonColor
        // Sets the lap_Name to the inputed value.
        fromViewController.lap1Name = lap1Name
        fromViewController.lap2Name = lap2Name
        fromViewController.lap3Name = lap3Name
        fromViewController.lap4Name = lap4Name
        // Tell the ``StopWatchViewController`` to update it's screen so the values fix themselves.
        Task { await fromViewController.updateScreen() }
        fromViewController.passedFromStopWatchSettings = true
        dismiss(animated: true) { [self] in
            fromViewController.resetLapTableView()
        }
    }
    
    // MARK: Functions
    
    func updateTheme(primary: UIColor, secondary: UIColor, background: UIColor) {
        stopwatchSettingsView.backgroundColor = background
        confirmButton.tintColor = primary
    }
}

