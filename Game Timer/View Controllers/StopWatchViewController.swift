//
//  StopWatchViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/12/23.
//

import UIKit

class StopWatchViewController: UIViewController {
    // MARK: --- Misc Functions ---
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.restorationIdentifier == "StopWatch"{
            Task { await updateScreen() }
        }
        
        // Initializes lapButtonColors
        lap1ButtonColor = primaryColor
        lap2ButtonColor = primaryColor
        lap3ButtonColor = primaryColor
        lap4ButtonColor = primaryColor
        
        lap1LabelColor = lap1ColorWell?.selectedColor ?? labelColor
        lap2LabelColor = lap2ColorWell?.selectedColor ?? labelColor
        lap3LabelColor = lap3ColorWell?.selectedColor ?? labelColor
        lap4LabelColor = lap4ColorWell?.selectedColor ?? labelColor
    }
    
    
    // Closes the keyboard when the screen is tapped.
    @IBAction func debugManualUpdate(_ sender: UIButton) {
        
        
        // TODO: Currently does not work 
        Theme.selectedTheme = Theme(customLabelColor: .brown, customPrimaryColor: .cyan, customBackgroundColor: .green)
        
        
        Task { await updateScreen() }
        print("Laps: ")
        print("      Lap 1: ")
        print("          Label:        '\(lap1Name)'")
        print("          Label Color:  \(String(describing: lap1LabelColor))")
        print("          Button Color: \(String(describing: lap1ButtonColor))")
        print("     Lap 2: ")
        print("          Label:        '\(lap2Name)'")
        print("          Label Color:  \(String(describing: lap2LabelColor))")
        print("          Button Color: \(String(describing: lap2ButtonColor))")
        print("     Lap 3: ")
        print("          Label:        '\(lap3Name)'")
        print("          Label Color:  \(String(describing: lap3LabelColor))")
        print("          Button Color: \(String(describing: lap3ButtonColor))")
        print("     Lap 4: ")
        print("          Label:        '\(lap4Name)'")
        print("          Label Color:  \(String(describing: lap4LabelColor))")
        print("          Button Color: \(String(describing: lap4ButtonColor))")
        
        print("\n")
        
        print("Stop Watch Time: ")
        print("     Seconds:    \(seconds)")
        print("     Minutes:    \(minutes)")
        print("     Hours:      \(hours)")
        print("     Days:       \(days)")
        
        print("\n")
        
        print("Theme Info: ")
        print("     primaryColor:       \(primaryColor)")
        print("     labelColor:         \(labelColor)")
        print("     backgroundColor:    \(backgroundColor)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // When screen is touched..
        self.view.endEditing(true) // Close the keyboard/keypad
    }
    
    
    
    // MARK: --- StopWatch ---
    
    // MARK: Variables/Constants
    // -- Simple Variables/Constants --
    // Variables/Constants that ARE NOT computed
    
    /// Is the stop-watch actively counting?
    ///
    /// Default: false
    var isGoing: Bool = false
    
    //      Theme Variables
    // Mainly for readability
    lazy var primaryColor: UIColor    = Theme.selectedTheme.customPrimaryColor
    lazy var secondaryColor: UIColor  = Theme.selectedTheme.customSecondaryColor
    lazy var labelColor: UIColor      = Theme.selectedTheme.customLabelColor
    lazy var backgroundColor: UIColor = Theme.selectedTheme.customBackgroundColor
    
    
    // Custom Lap names. The user is able to edit these on the Stop Watch Settings screen.
    /// The custom name for the ``lap1Button``.label
    var lap1Name: String = "Lap 1"
    var lap2Name: String = "Lap 2"
    var lap3Name: String = "Lap 3"
    var lap4Name: String = "Lap 4"
    
    var lap1ButtonColor: UIColor!
    var lap2ButtonColor: UIColor!
    var lap3ButtonColor: UIColor!
    var lap4ButtonColor: UIColor!
    
    var lap1LabelColor: UIColor!
    var lap2LabelColor: UIColor!
    var lap3LabelColor: UIColor!
    var lap4LabelColor: UIColor!

    
    
    // -- Complex Variables/Constants --
    // Variables/Constants that ARE computed
    
    // Time:
    
    /// Used to display the seconds for the stop-watch.
    ///
    /// Represented by ``secondsLabel``.
    ///
    /// - DidSet:
    ///
    /// When seconds is set, it will check if seconds >= 60, in which case it will remove 60 seconds and add 1 minute.
    ///
    /// It will also attempt to update the screen so that the stopwatch display is up-to-date.
    var seconds: Int = 0 {
        didSet {
            // Adding Minutes.
            if seconds >= 60 {  /// When 'seconds' gets to or over 60..
                seconds -= 60   /// Remove 60 seconds..
                minutes += 1    /// Add 1 minute.
            }
            Task { await updateScreen() } /// Starts another thread that updates the screen.
            
        }
    }
    
    /// Used to display the minutes for the stop-watch.
    ///
    /// Represented by ``minutesLabel``.
    ///
    /// - DidSet:
    ///
    /// When minutes is set, it will check if minutes >= 60, in which case it will remove 60 minutes and add 1 hour.
    var minutes: Int = 0 {
        didSet {
            // Adding Hours.
            if minutes >= 60 {              /// When 'minutes' gets to or over 60..
                print("Adding 1 hour.")     /// Prints that 1 hour is being added.
                minutes -= 60               /// Remove 60 minutes..
                hours += 1                  /// Add 1 hour.
            }
            /// Update screen is not needed here because it is updated regardless.
        }
    }
    
    /// Used to display the hours for the stop-watch.
    ///
    /// Represented by ``hoursLabel``.
    ///
    /// - DidSet:
    ///
    /// When hours is set, it will check if hours >= 60, in which case it will remove 60 hours and add 1 day.
    var hours:   Int = 0 {
        didSet {
            // Adding day.
            if hours >= 60 {                  /// When 'hours' gets to or over 60..
                print("Adding 1 hour.")       /// Prints that 1 day is being added.
                hours -= 60                   /// Remove 60 hours..
                days += 1                     /// Add 1 day.
            }
            /// Update screen is not needed here because it is updated regardless.
        }
    }
    
    /// Used to display the days for the stop-watch.
    ///
    /// Represented by ``daysLabel``.
    var days:    Int = 0
    // Days does not have a didSet as it is the largest item that is represented.
    
    // MARK: Outlets
    // These outlets are used on the main stop-watch screen.
    /// A label that displays the ``seconds`` integer on the screen
    @IBOutlet weak var secondsLabel: UILabel!
    /// A label that displays the ``minutes`` integer on the screen
    @IBOutlet weak var minutesLabel: UILabel!
    /// A label that displays the ``hours`` integer on the screen.
    @IBOutlet weak var hoursLabel:   UILabel!
    /// A label that displays the ``days`` integer on the screen.
    @IBOutlet weak var daysLabel:    UILabel!
    /// A button that is used to clear the stop-watch.
    ///
    /// Pressing the button will reset ``seconds``, ``minutes``, ``hours``, and ``days``.
    ///
    /// Pressing the button while the stop-watch is blank will remove all cells inside ``lapTableView``, thus reseting the stop-watch.
    @IBOutlet weak var clearButton:      UIButton!
    /// A button that, when pressed, creates a ``Lap``.
    @IBOutlet weak var lap1Button:       UIButton!
    /// A button that, when pressed, creates a ``Lap``.
    @IBOutlet weak var lap2Button:       UIButton!
    /// A button that, when pressed, creates a ``Lap``.
    @IBOutlet weak var lap3Button:       UIButton!
    /// A button that, when pressed, creates a ``Lap``.
    @IBOutlet weak var lap4Button:       UIButton!
    /// A button that, when pressed, starts or stops the stop-watch.
    @IBOutlet weak var startStopButton:  UIButton!
    /// A button that, when pressed, opens another screen called `StopWatchSettings`.
    @IBOutlet weak var settingsButton:   UIButton!
    /// A table view that is used to represent ``Lap``s.
    @IBOutlet weak var lapTableView:     UITableView!
    
    
    // MARK: Functions:
    
    /// Updates the screen and makes sure everything is labeled correctly.
    ///
    /// This function is async so that it may run on a background thread, and thus can be run without interupting other functions.
    func updateScreen() async {
        // Updates the stop-watch labels.
        /// Sets the secondsLabel to ``seconds``. If the amount of characters in seconds == 1(single place), put a 0 in front.
        secondsLabel.text = (String(seconds).count == 1 ? "0\(String(seconds))" : String(seconds))
        /// Sets the secondsLabel to ``minutes``. If the amount of characters in seconds == 1(single place), put a 0 in front.
        minutesLabel.text = (String(minutes).count == 1 ? "0\(String(minutes))" : String(minutes))
        /// Sets the secondsLabel to ``hours``. If the amount of characters in seconds == 1(single place), put a 0 in front.
        hoursLabel.text = (String(hours).count == 1 ? "0\(String(hours))" : String(hours))
        /// Sets the secondsLabel to ``days``. If the amount of characters in seconds == 1(single place), put a 0 in front.
        daysLabel.text = (String(days).count == 1 ? "0\(String(days)) Days" : "\(String(days)) Days")

        // Colors the buttons
        lap1Button.backgroundColor = lap1ButtonColor
        lap2Button.backgroundColor = lap2ButtonColor
        lap3Button.backgroundColor = lap3ButtonColor
        lap4Button.backgroundColor = lap4ButtonColor
        
        startStopButton.backgroundColor = primaryColor
        clearButton.backgroundColor = primaryColor
        settingsButton.backgroundColor = secondaryColor
        
    }
    
    
    // MARK: --- Settings ---
    
    // MARK: Variables/Constants
    // -- Simple Variables/Constants --
    // Variables/Constants that ARE NOT computed
    
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
}


/// A time-stamp a user can create.
///
/// Used primarily for ``StopWatchViewController`` to show and create laps on a table-view(``StopWatchViewController/lapTableView``).
struct Lap {
    /// How many seconds was shown when this lap was created.
    let seconds: Int
    /// How many mintues was shown when this lap was created.
    let minutes: Int
    /// How many hours was shown when this lap was created.
    let hours:   Int
    /// The name of the type.
    let type:    String
    /// The Lap's color set in the Stop-Watch-Settings.
    let color: UIColor
}


// TODO: Fix segways.
/// As of right now, it does not save info from the settings screen.
