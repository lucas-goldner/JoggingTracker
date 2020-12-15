//
//  NewRunViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit
import CoreLocation

class NewRunViewController: UIViewController {
    @IBOutlet weak var StartButtonStyle: UIButton!
    @IBAction func StartButton(_ sender: Any) {
        startRun()
    }
    @IBOutlet weak var StopStyle: UIButton!
    @IBAction func StopButton(_ sender: Any) {
        stopRun()
    }
    @IBOutlet weak var DistanceLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var PaceLabel: UILabel!
    private var run: Run?
    private let locationManager = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartButtonStyle.isHidden = false
        StopStyle.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.invalidate()
      locationManager.stopUpdatingLocation()
    }
    
    func eachSecond() {
      seconds += 1
      updateDisplay()
    }

    private func updateDisplay() {
      let formattedDistance = FormatDisplay.distance(distance)
      let formattedTime = FormatDisplay.time(seconds)
      let formattedPace = FormatDisplay.pace(distance: distance,
                                             seconds: seconds,
                                             outputUnit: UnitSpeed.minutesPerMile)
       
        DistanceLabel.text = "Distance:  \(formattedDistance)"
        TimeLabel.text = "Time:  \(formattedTime)"
        PaceLabel.text = "Pace:  \(formattedPace)"
    }
    
    private func startRun() {
        StartButtonStyle.isHidden = true
        StopStyle.isHidden = false
    }
    
    private func stopRun() {
        StartButtonStyle.isHidden = false
        StopStyle.isHidden = true
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.sendToResult()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
          self.stopRun()
          _ = self.navigationController?.popToRootViewController(animated: true)
        })
            
        present(alertController, animated: true)
        
       
    }
    
    func sendToResult() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "doneRun") as! RunsListViewController
        nextViewController.run = run
        self.present(nextViewController, animated:true, completion:nil)
    }

}

