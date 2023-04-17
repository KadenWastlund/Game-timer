//
//  TimerViewController.swift
//  Game Timer
//
//  Created by Kaden Wastlund on 4/11/23.
//


// TODO: Make Pretty

import AVFoundation
import UIKit

class TimerViewController: UIViewController {
    var player: AVAudioPlayer?
    
    func playAudio() {
        guard let audioFileURL = Bundle.main.url(forResource: "alarmTone", withExtension: "wav") else {
            print("Error: audio file not found")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioFileURL)
            if timesOut{
                player?.play()
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBOutlet weak var timerRangeStack: UIStackView!
    @IBOutlet weak var timerRangeLabel: UIStackView!
    @IBOutlet weak var timerRangeMinInput: UITextField!
    @IBOutlet weak var timerRangeMaxInput: UITextField!
    @IBOutlet weak var timerRangeMinLabel: UILabel!
    @IBOutlet weak var timerRangeMaxLabel: UILabel!
    @IBOutlet weak var timerConstantTxtBox: UITextField!
    @IBOutlet weak var randomSwitchButton: UISwitch!
    @IBAction func randomSwitch(_ sender: UISwitch) {
        isRandom = randomSwitchButton.isOn
        if randomSwitchButton.isOn {
            // Hide Constant
            timerConstantTxtBox.isHidden = true
            // Show Range
            timerRangeStack.isHidden = false
            timerRangeLabel.isHidden = false
        } else {
            // Hide Range
            timerRangeStack.isHidden = true
            timerRangeLabel.isHidden = true
            // Show Constant
            timerConstantTxtBox.isHidden = false
        }
    }
    
    @IBAction func timerInputEditEnd(_ sender: UITextField) {
        if sender.hasText { // If the constant has text..
            sender.text = String(Int(sender.text ?? "0") ?? 0)
            timeSet = Int(sender.text!) ?? 0 // Set the 'timeSet' variable
            currentTime = timeSet // Update the currentTime
            updateTimer() // Update the timer label
            sender.text = "" // Clear the text box.
        }
    }
    @IBAction func timerMinInputEditEnd(_ sender: UITextField) {
        if sender.hasText { // If the constant has text..
            sender.text = String(Int(sender.text ?? "0") ?? 0)
            updateTimer() // Update the timer label
            min = Int(timerRangeMinInput.text ?? "Min") ?? 0
            sender.text = "" // Clear the text box.
        }
    }
    @IBAction func timerMaxInputEditEnd(_ sender: UITextField) {
        if sender.hasText { // If the constant has text..
            sender.text = String(Int(sender.text ?? "0") ?? 0)
            updateTimer() // Update the timer label
            max = Int(timerRangeMaxInput.text ?? "Max") ?? 0
            sender.text = "" // Clear the text box.
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { // When screen is touched..
        self.view.endEditing(true) // Close the keyboard/keypad
    }
    
    @IBOutlet weak var timerInputTxtBox: UIStackView!
    
    var isRandom: Bool = false
    var min: Int = 0 {
        didSet {
            if max < min && timerRangeMaxLabel.text != "Max" { min = max }
            timerRangeMinLabel.text = String(min)// Set the label underneathe to the number inputed by the user.
            
            if timerRangeMinLabel.text != "Min" && timerRangeMaxLabel.text != "Max" {
                timeSet = Int.random(in: randomRange) // Set the timer to a random time between min and max.
                currentTime = timeSet
                updateTimer() // Set the timerLabel
                timerRangeMaxLabel.text = "Max" // Reset the values
                timerRangeMinLabel.text = "Min" // Reset the values
            }
        }
    }
    var max: Int = 0 {
        didSet {
            if max < min && timerRangeMinLabel.text != "Min" { max = min }
            timerRangeMaxLabel.text = String(max) // Set the label underneathe to the number inputed by the user.
            
            if timerRangeMinLabel.text != "Min" && timerRangeMaxLabel.text != "Max" {
                timeSet = Int.random(in: randomRange) // Set the timer to a random time between min and max.
                currentTime = timeSet
                updateTimer() // Set the timerLabel
                timerRangeMaxLabel.text = "Max" // Reset the values
                timerRangeMinLabel.text = "Min" // Reset the values
            }
        }
    }
    var randomRange: ClosedRange<Int> {
        return (min...max)
    }
    
    var currentTime: Int = 0 {
        didSet {
            print("Current Time: \(currentTime)")
            if currentTime <= 0 && timeSet != 0 { // If the current time is equal to or less than 0..
                isGoing = false // Stop the timer
                print("Time is out!")
                timesOut = true // Set timesOut to true (see timesOut didSet for more information)
                startTimerButtonOutlet.isEnabled = false
            }
            if currentTime == timeSet {
                timerBar.setProgress(1.0, animated: true)
            }
        }
        willSet {
            let progress: Float = Float(Float(Float(currentTime)-Float(timeSet) / Float(timeSet)) / Float(timeSet))
            timerBar.setProgress(progress, animated: true)
            print(String(progress))
        }
    }
    var timeSet: Int = 10 { // Time set, this will only change when the user inputs a value.
        didSet {
            startTimerButtonOutlet.isEnabled = true
        }
    }
    var isPaused: Bool = false { // Used to pause the timer throughout the code.
        didSet { // When set..
            if isPaused { // When paused..
                print("--Timer Paused at \(currentTime) seconds...--")
                isGoing = false // Set isGoing to false (see isGoing didSet for more info)
                startTimerButtonOutlet.isEnabled = true // 'Light up' the start timer button.
                pauseButtonOutlet.isEnabled = false // 'dim' the pause timer button.
            } else { // When unpaused..
                print("--Timer unpaused!--")
                isGoing = true // Set isGoing to true (see isGoing didSet for more info)
                startTimerButtonOutlet.isEnabled = false // 'dim' the start timer button.
                pauseButtonOutlet.isEnabled = true // 'Ligh up' the pause timer button.
            }
        }
    }
    var mainTimer: Timer = Timer() // The timer that is displayed on the main screen.
    var isGoing: Bool = false { // Used programically to keep timers going.
        didSet { // When changed..
            print("isGoing = \(isGoing)")
            if !isGoing { // If timer is not going
                mainTimer.invalidate() // Stop the timer.
            }
            // Give/Removes access to change values in the inputs. (
            randomSwitchButton.isEnabled = !isGoing
            timerRangeMaxInput.isEnabled = !isGoing
            timerRangeMinInput.isEnabled = !isGoing
            timerConstantTxtBox.isEnabled = !isGoing
            // )
        }
    }
    var timerHidden: Bool = false
    
    
    
    func setToConstant() {
        timerRangeStack.isHidden = true
        timerRangeLabel.isHidden = true
        randomSwitchButton.isOn = false
    }
    
    @IBOutlet weak var randomStack: UIStackView!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBAction func hideInterfaceButton(_ sender: UIButton) {
        buttonStackView.isHidden = true
        setToConstant()
        timerConstantTxtBox.isHidden = true
        randomStack.isHidden = true
        unHideButton.isHidden = false
    }
    @IBOutlet weak var unHideButton: UIButton!
    @IBAction func unHideInterfaceButton(_ sender: UIButton) {
        buttonStackView.isHidden = false
        setToConstant()
        timerConstantTxtBox.isHidden = false
        randomStack.isHidden = false
        unHideButton.isHidden = true
    }
    
    @IBOutlet weak var hideShowTimerButton: UIButton!
    
    @IBAction func hideShowTimer(_ sender: UIButton) {
        if timerHidden { // If the timer is hidden..
            print("Showing Timer")
            hideShowTimerButton.setTitle("Hide Timer", for: .normal) // Change the button's text
            timerLabel.isHidden = false // Sets the timer label to be shown
            timerBar.isHidden = false
            timerHidden = false // Sets the boolean
        } else {
            print("Hiding Timer")
            hideShowTimerButton.setTitle("Show Timer", for: .normal) // Change the button's text
            timerLabel.isHidden = true // Sets the timer label to be hidden
            timerBar.isHidden = true
            timerHidden = true // Sets the boolean
        }
    }
    
    
    @IBOutlet weak var timerBar: UIProgressView!
    @IBOutlet weak var startTimerButtonOutlet: UIButton!
    @IBAction func startTimerButton(_ sender: UIButton) {
        isPaused = false // Unpause the timer
        print("Starting Timer for \(timeSet) seconds.")
        isGoing = true // Set isGoing
        
        if currentTime > 0 { // If the timer isn't set to 0..
            mainTimer = .scheduledTimer(withTimeInterval: TimeInterval(1), repeats: true, block: { [self] _ in // Start a timer..
                currentTime -= 1 // That counts down
                updateTimer() // Update the timer label
            })
        } else {
            timesOut = true
        }
    }
    
    func updateTimer() { // Updates the timer label
        timerLabel.text = String(currentTime) // Set the label to how much time is left.
    }
    
    @IBOutlet weak var pauseButtonOutlet: UIButton!
    @IBAction func pauseButton(_ sender: UIButton) { // When the pause button is pressed..
        isPaused = true // Set paused to true
    }
    @IBOutlet weak var resetButtonOutlet: UIButton!
    @IBAction func resetButton(_ sender: UIButton) { // When the reset button is pressed..
        resetTimer() // Reset the timer
    }
    private func resetTimer() { // Resets the timer
        print("--Timer Reseting..--")
        isPaused = true // Pause the timer
        currentTime = 0 // Set the current time to 0.
        timerBar.setProgress(1.0, animated: true)
        timesOut = false // Reset the timesOut boolean (See timesOut didSet for more information)
        timesOutAnimationTimer.invalidate()
        updateTimer() // Set the label text.
        print("--Timer Reset.--")
    }
    
    var timesOut: Bool = false {
        didSet { // When set..
            if timesOut { // If time is out..
                timeIsOut()
            } else { // If time is not out
                stopTimeIsOut()
            }
        }
    }
    func timeIsOut() {
        pauseButtonOutlet.isEnabled = false // 'Dim' the pause button
        timesOutAnimationTimer = .scheduledTimer(withTimeInterval: TimeInterval(2), repeats: false, block: {[self] _ in // Start a timer of 2 seconds
            playAudio()
            Task { await updateTimerLabelBackgroundColor(color: .red) } // Set the timerLabelBackgroundColor to red.
            _ = Timer.scheduledTimer(withTimeInterval: TimeInterval(1), repeats: false) {[self] _ in // Start another timer of 1 second
                Task { await updateTimerLabelBackgroundColor(color: .clear) } // Set the timerLabelColor to clear.
            }
            if timesOut {
                timeIsOut()
            }
        })
    }
    func stopTimeIsOut() {
        print("Killing timesOut timer")
        timesOutAnimationTimer.invalidate() // Attempt to kill the animation timer.
        player?.stop()
        Task { await updateTimerLabelBackgroundColor(color: .clear) } // Set the timerLabelBackgroundColor to clear.
    }
    
    
    var timesOutAnimationTimer: Timer = Timer()
    
    
    func updateTimerLabelBackgroundColor(color: UIColor) async {
        if timesOut {
            timerLabel.backgroundColor = color
        } else {
            timesOutAnimationTimer.invalidate()
            timerLabel.backgroundColor = .clear
        }
    }
}
