//
//  StopWatchViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/12/23.
//

import UIKit
import Foundation

class StopWatchViewController: UIViewController {
    // MARK: --- Misc Functions ---
    override func viewWillAppear(_ animated: Bool) {
        // Sets the theme
        stopwatchView.backgroundColor = Theme.selectedTheme.customBackgroundColor
        startStopButton.tintColor = Theme.selectedTheme.customPrimaryColor
        clearButton.tintColor = Theme.selectedTheme.customPrimaryColor
        lapTableView.backgroundColor = Theme.selectedTheme.customSecondaryColor
        settingsButton.tintColor = Theme.selectedTheme.customSecondaryColor
        
        // Sets the buttonLabels to change their size depending on the fomt size.
        lap1Button.titleLabel?.adjustsFontSizeToFitWidth = true
        lap2Button.titleLabel?.adjustsFontSizeToFitWidth = true
        lap3Button.titleLabel?.adjustsFontSizeToFitWidth = true
        lap4Button.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializes lapButtonColors
        lap1Color = primaryColor
        lap2Color = primaryColor
        lap3Color = primaryColor
        lap4Color = primaryColor
        
        
        if restorationIdentifier == "StopWatch" {
            // Initializes the tableview.
            lapTableView.delegate = self
            lapTableView.dataSource = self
            
            // Set the ClearButton's subtitle to tell the user that you can't clear if there is not count.
            clearButton.configuration?.subtitle = "Cannot clear when nothing is clearable"
            
            Task { await updateScreen() }
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // When screen is touched..
        self.view.endEditing(true) // Close the keyboard/keypad
    }
    
    
    
    
    
    // MARK: --- StopWatch ---
    
    // MARK: Variables/Constants
    // -- Simple Variables/Constants --
    // Variables/Constants that ARE NOT computed
    
    /// Has the settings been edited?
    var passedFromStopWatchSettings: Bool = false
    
    
    /// Is the stop-watch actively counting?
    ///
    /// Default: false
    var isGoing: Bool = false
    
    /// The timer between each 1 second.
    var stopWatchTimer: Timer = Timer()
    
    //      Theme Variables
    // Mainly for readability
    lazy var primaryColor: UIColor    = Theme.selectedTheme.customPrimaryColor
    lazy var secondaryColor: UIColor  = Theme.selectedTheme.customSecondaryColor
    lazy var backgroundColor: UIColor = Theme.selectedTheme.customBackgroundColor
    
    
    // Custom Lap names. The user is able to edit these on the Stop Watch Settings screen.
    /// The custom name for the ``lap1Button``.label
    var lap1Name: String = "Lap 1"
    /// The custom name for the ``lap2Button``.label
    var lap2Name: String = "Lap 2"
    /// The custom name for the ``lap3Button``.label
    var lap3Name: String = "Lap 3"
    /// The custom name for the ``lap4Button``.label
    var lap4Name: String = "Lap 4"
    
    var lap1Color: UIColor!
    var lap2Color: UIColor!
    var lap3Color: UIColor!
    var lap4Color: UIColor!
    
    /// An array of all the laps that are to be stored on the ``lapTableView``.
    var laps: [Lap] = []
    
    var type1Laps: [Lap] = []
    var type2Laps: [Lap] = []
    var type3Laps: [Lap] = []
    var type4Laps: [Lap] = []
    
    // -- Complex Variables/Constants --
    // Variables/Constants that ARE computed
    
    // Time:
    
    /// Used to display and calculate mili-seconds
    var milliSeconds: Int = 0 {
        didSet {
            if milliSeconds >= 100 {
                milliSeconds -= 100
                seconds += 1
            }
            /// The milliseconds label is changed independentally to compete against lag.
            milliSecondsLabel.text = String(milliSeconds)
        }
    }
    
    
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
    var hours: Int = 0 {
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
    var days: Int = 0
    // Days does not have a didSet as it is the largest item that is represented.
    
    // MARK: Outlets
    // These outlets are used on the main stop-watch screen.
    
    /// The main view of the View Controller.
    @IBOutlet var stopwatchView: UIView!
    
    /// A label that displays the ``milliSeconds`` integer on the screen.
    @IBOutlet weak var milliSecondsLabel:   UILabel!
    /// A label that displays the ``seconds`` integer on the screen
    @IBOutlet weak var secondsLabel:        UILabel!
    /// A label that displays the ``minutes`` integer on the screen
    @IBOutlet weak var minutesLabel:        UILabel!
    /// A label that displays the ``hours`` integer on the screen.
    @IBOutlet weak var hoursLabel:          UILabel!
    /// A label that displays the ``days`` integer on the screen.
    @IBOutlet weak var daysLabel:           UILabel!
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
    
    
    // MARK: Actions
    
    /// When the user presses the ``startStopButton`` on the ``StopWatchViewController``.
    @IBAction func startStopButtonPress(_ sender: UIButton) {
        startStop_StopWatch()
    }
    /// When the user presses the ``clearButton`` on the ``StopWatchViewController``
    @IBAction func clearButtonPress(_ sender: UIButton) {
        resetTimer()
    }
    
    @IBAction func lap1ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap1Name, milliSeconds: milliSeconds, seconds: seconds, minutes: minutes, hours: hours, days: days, color: lap1Color)
    }
    @IBAction func lap2ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap2Name, milliSeconds: milliSeconds, seconds: seconds, minutes: minutes, hours: hours, days: days, color: lap2Color)
    }
    @IBAction func lap3ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap3Name, milliSeconds: milliSeconds, seconds: seconds, minutes: minutes, hours: hours, days: days, color: lap3Color)
    }
    @IBAction func lap4ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap4Name, milliSeconds: milliSeconds, seconds: seconds, minutes: minutes, hours: hours, days: days, color: lap4Color)
    }
    
    
    // MARK: Functions
    
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
        lap1Button.tintColor = lap1Color
        lap2Button.tintColor = lap2Color
        lap3Button.tintColor = lap3Color
        lap4Button.tintColor = lap4Color
        
        // Sets the titles to the custom names.
        lap1Button.setTitle(lap1Name, for: .normal)
        lap2Button.setTitle(lap2Name, for: .normal)
        lap3Button.setTitle(lap3Name, for: .normal)
        lap4Button.setTitle(lap4Name, for: .normal)
        lap1Button.titleLabel?.adjustsFontSizeToFitWidth = true
        lap2Button.titleLabel?.adjustsFontSizeToFitWidth = true
        lap3Button.titleLabel?.adjustsFontSizeToFitWidth = true
        lap4Button.titleLabel?.adjustsFontSizeToFitWidth = true
        
        // Sets the theme for the buttons
        startStopButton.tintColor = primaryColor
        clearButton.tintColor = primaryColor
        settingsButton.tintColor = secondaryColor
    }
    
    /// Starts the stopwatch and updates it.
    func startStop_StopWatch() {
        if !isGoing {
            isGoing = true
            // Enabled the lap buttons
            lap1Button.isEnabled = true
            lap2Button.isEnabled = true
            lap3Button.isEnabled = true
            lap4Button.isEnabled = true
            /// The clear button is disabled to prevent accidental reseting.
            clearButton.isEnabled = false
            /// Tells the user why the clearbutton is disabled
            clearButton.configuration?.subtitle = "Cannot clear while stop watch is running"
            startStopButton.configuration?.title = "Stop"
            stopWatchTimer = .scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [self] timer in
                milliSeconds += 1
                
                Task { await updateScreen() }
            })
            RunLoop.current.add(stopWatchTimer, forMode: RunLoop.Mode.common)
        } else {
            isGoing = false
            
            /// The clear button is re-enabled.
            clearButton.isEnabled = true
            clearButton.configuration?.subtitle = "Press to clear everything"
            startStopButton.configuration?.title = "Start"
            stopWatchTimer.invalidate()
        }
    }
    
    /// Resets the timer, and will clear the ``lapTableView`` when pressed if the stop-watch is empty.
    func resetTimer(){
        if clearButton.subtitleLabel?.text != "Are you sure you want to clear everything?" {
            clearButton.isEnabled = true
            clearButton.configuration?.subtitle = "Are you sure you want to clear everything?"
            clearButton.tintColor = Theme.selectedTheme.customSecondaryColor
        } else {
            // Clear the table-view.
            laps = []
            lapTableView.reloadData()
            clearButton.isEnabled = false
            clearButton.configuration?.subtitle = "Cannot clear when nothing is clearable"
            
            // Disables all the lap buttons to prevent '0 days, 0:0:0:0' laps.
            lap1Button.isEnabled = false
            lap2Button.isEnabled = false
            lap3Button.isEnabled = false
            lap4Button.isEnabled = false
            
            // Clears the stop-watch counter
            milliSeconds = 0
            seconds = 0
            minutes = 0
            hours = 0
            days = 0
            
            clearButton.isEnabled = false
            clearButton.configuration?.subtitle = "Cannot clear when nothing is clearable"
            
            clearButton.tintColor = Theme.selectedTheme.customPrimaryColor
            
            Task { await updateScreen() }
        }
    }
    
    /// Creates a lap and put it on the ``lapTableView``.
    func createLap(lapName: String, milliSeconds: Int, seconds: Int, minutes: Int, hours: Int, days: Int, color: UIColor) {
        let lap = Lap(milliSeconds: milliSeconds, seconds: seconds, minutes: minutes, hours: hours, days: days, type: lapName, color: color)
        
        laps.append(lap)
        switch lap.type{
        case lap1Name: type1Laps.append(lap)
        case lap2Name: type2Laps.append(lap)
        case lap3Name: type3Laps.append(lap)
        case lap4Name: type4Laps.append(lap)
        default: print("lap.type doesn't sort.")
        }
        lapTableView.beginUpdates()
        lapTableView.insertRows(at: [IndexPath(row: laps.count-1, section: 0)], with: .automatic)
        lapTableView.endUpdates()
        if restorationIdentifier == "StopWatch" {
            lapTableView.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: .middle, animated: true)
        }
    }
    
    func resetLapTableView() {
        // Resets the table.
        lapTableView.reloadData()
    }
    
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StopWatchSettingsViewController {
            // Passes the viewcontroller so that it can be edited.
            vc.fromViewController = self
            // Passes the button colors so the colorPickers have a default value, also fixes a bug where the colors will reset to .tintColor if not chosen.
            vc.lap1ButtonColor = lap1Color
            vc.lap2ButtonColor = lap2Color
            vc.lap3ButtonColor = lap3Color
            vc.lap4ButtonColor = lap4Color
            // Passes the button maes so the text boxes have a default value, also fixes a bug where the names will reset to "lap _" if not chosen.
            vc.lap1Name = lap1Name
            vc.lap2Name = lap2Name
            vc.lap3Name = lap3Name
            vc.lap4Name = lap4Name
        }
    }
}


/// A time-stamp a user can create.
///
/// Used primarily for ``StopWatchViewController`` to show and create laps on a table-view(``StopWatchViewController/lapTableView``).
struct Lap {
    /// How many milliSeconds were shown when this lap was created.
    let milliSeconds: Int
    /// How many seconds were shown when this lap was created.
    let seconds: Int
    /// How many mintues were shown when this lap was created.
    let minutes: Int
    /// How many hours were shown when this lap was created.
    let hours:   Int
    /// How many days were shown when this lap was created.
    let days:    Int
    /// The name of the type.
    let type:    String
    /// The Lap's color set in the Stop-Watch-Settings.
    let color: UIColor
    /// The message that is printed onto the ``StopWatchViewController/lapTableView``.
    lazy var displayedMessage: String = "\(type): \(days) days; \(hours):\(minutes):\(seconds).\(milliSeconds)"
    
    // MARK: Computed Properties
    var timeInMilliSeconds: Int {
        var totalTime: Int = 0
        
        totalTime += milliSeconds
        totalTime += seconds * 100
        totalTime += minutes * 60 * 100
        totalTime += hours   * 60 * 60 * 100
        totalTime += days    * 24 * 60 * 60 * 100
        
        return totalTime
    }
}


extension StopWatchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Tapped")
    }
}

extension StopWatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var selectedLap: Lap = laps[indexPath.row]
        var lastCellOfSameType: Lap = Lap(milliSeconds: 0, seconds: 0, minutes: 0, hours: 0, days: 0, type: "DEBUGGINGMADNESS", color: .black)
        
        switch selectedLap.type{
        case lap1Name:
            if type1Laps.count > 1 {
                lastCellOfSameType = type1Laps[type1Laps.count-2]
            }
        case lap2Name:
            if type2Laps.count > 1 {
                lastCellOfSameType = type2Laps[type2Laps.count-2]
            }
        case lap3Name:
            if type3Laps.count > 1 {
                lastCellOfSameType = type3Laps[type3Laps.count-2]
            }
        case lap4Name:
            if type4Laps.count > 1 {
                lastCellOfSameType = type4Laps[type4Laps.count-2]
            }
        default: print("selectedLap.type doesn't sort.")
        }
        
        var secondsFromLastCellOfSameType: Int = Int(
            (
                (
                    Double(selectedLap.timeInMilliSeconds)
                                    -
                    Double(lastCellOfSameType.timeInMilliSeconds)
                ) / 100
            ).rounded(.down)
        )
        
        var milliSecondsFromLastCellOfSameType: Int = Int(
            (selectedLap.timeInMilliSeconds - lastCellOfSameType.timeInMilliSeconds)
                                -
            secondsFromLastCellOfSameType * 100
        )
        
        if secondsFromLastCellOfSameType < 0 {
            secondsFromLastCellOfSameType = 0
            milliSecondsFromLastCellOfSameType = 0
        }
        
        cell.textLabel?.text = selectedLap.displayedMessage + " | + \(secondsFromLastCellOfSameType).\(milliSecondsFromLastCellOfSameType) seconds"
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        print("")
        print("Selected Lap's Type: \(selectedLap.type)")
        print("Last Lap's Type: \(lastCellOfSameType.type)")
        print("")
        print("Selected Laps' Milliseconds: \(selectedLap.timeInMilliSeconds)")
        print("Last Laps's Milliseconds: \(lastCellOfSameType.timeInMilliSeconds)")
        print("Seconds From Last Cell of Same Type: \(secondsFromLastCellOfSameType)")
        print("MilliSeconds From Last Cell of Same Type: \(milliSecondsFromLastCellOfSameType)")
        
        switch selectedLap.type{
        case lap1Name: cell.backgroundColor = lap1Color
        case lap2Name: cell.backgroundColor = lap2Color
        case lap3Name: cell.backgroundColor = lap3Color
        case lap4Name: cell.backgroundColor = lap4Color
        default: cell.backgroundColor = .red
        }
        
        return cell
    }
}
