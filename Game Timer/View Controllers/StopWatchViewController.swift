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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initializes lapButtonColors
        lap1ButtonColor = primaryColor
        lap2ButtonColor = primaryColor
        lap3ButtonColor = primaryColor
        lap4ButtonColor = primaryColor
        
        lap1LabelColor = labelColor
        lap2LabelColor = labelColor
        lap3LabelColor = labelColor
        lap4LabelColor = labelColor
        
        if restorationIdentifier == "StopWatch"{
            // Initializes the tableview.
            lapTableView.delegate = self
            lapTableView.dataSource = self
            
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
    lazy var labelColor: UIColor      = Theme.selectedTheme.customLabelColor
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
    
    var lap1ButtonColor: UIColor!
    var lap2ButtonColor: UIColor!
    var lap3ButtonColor: UIColor!
    var lap4ButtonColor: UIColor!
    
    var lap1LabelColor: UIColor!
    var lap2LabelColor: UIColor!
    var lap3LabelColor: UIColor!
    var lap4LabelColor: UIColor!
    
    var laps: [Lap] = []
    
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
    /// A label that displays the ``milliSeconds`` integer on the screen.
    @IBOutlet weak var milliSecondsLabel: UILabel!
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
        createLap(lapName: lap1Name)
    }
    @IBAction func lap2ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap2Name)
    }
    @IBAction func lap3ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap3Name)
    }
    @IBAction func lap4ButtonPress(_ sender: UIButton) {
        createLap(lapName: lap4Name)
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
        lap1Button.tintColor = lap1ButtonColor
        lap2Button.tintColor = lap2ButtonColor
        lap3Button.tintColor = lap3ButtonColor
        lap4Button.tintColor = lap4ButtonColor
        
        lap1Button.setTitle(lap1Name, for: .normal)
        lap2Button.setTitle(lap2Name, for: .normal)
        lap3Button.setTitle(lap3Name, for: .normal)
        lap4Button.setTitle(lap4Name, for: .normal)
        
        startStopButton.tintColor = primaryColor
        clearButton.tintColor = primaryColor
        settingsButton.tintColor = secondaryColor
        
//        Task {
//            lapTableView.reloadData
//            lapTableView.
//        }
    }
    
    /// Starts the stopwatch and updates it.
    func startStop_StopWatch() {
        if !isGoing {
            isGoing = true
            /// The clear button is disabled to prevent accidental reseting.
            clearButton.isEnabled = false
            startStopButton.setTitle("Stop", for: .normal)
            stopWatchTimer = .scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { [self] _ in
                milliSeconds += 1
                
                Task { await updateScreen() }
            })
        } else {
            isGoing = false
            /// The clear button is re-enabled.
            clearButton.isEnabled = true
            startStopButton.setTitle("Start", for: .normal)
            stopWatchTimer.invalidate()
        }
    }
    
    /// Resets the timer, and will clear the ``lapTableView`` when pressed if the stop-watch is empty.
    func resetTimer(){
        if (milliSeconds + seconds + minutes + hours + days) == 0 {
            // Clear the table-view.
            laps = []
            lapTableView.reloadData()
        } else {
            // Clears the stop-watch counter
            milliSeconds = 0
            seconds = 0
            minutes = 0
            hours = 0
            days = 0
            Task { await updateScreen() }
        }
    }
    
    /// Creates a lap and put it on the ``lapTableView``.
    func createLap(lapName: String) {
        laps.append(
            Lap(milliSeconds: milliSeconds, seconds: seconds, minutes: minutes, hours: hours, days: days, type: lapName, color: lap1ButtonColor)
        )
        lapTableView.beginUpdates()
        lapTableView.insertRows(at: [IndexPath(row: laps.count-1, section: 0)], with: .automatic)
        lapTableView.endUpdates()
        lapTableView.scrollToRow(at: IndexPath(row: laps.count-1, section: 0), at: .middle, animated: true)
    }
    
    
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? StopWatchSettingsViewController {
            vc.fromViewController = self
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
        
        cell.textLabel?.text = laps[indexPath.row].displayedMessage
        cell.backgroundColor = laps[indexPath.row].color
        // TODO: Set the color to what the button's color is.
        
        return cell
    }
}
