//
//  RunsListViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit

class RunsListViewController: UIViewController {
    @IBOutlet weak var TimeView: UITextView!
    @IBOutlet weak var PaceView: UITextView!
    @IBOutlet weak var DateView: UITextView!
    @IBOutlet weak var DistanceView: UITextView!
    var run: Run!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        print("easy")
    }
    
    private func configureView() {
        let distance = Measurement(value: run.distance, unit: UnitLength.meters)
         let seconds = Int(run.duration)
         let formattedDistance = FormatDisplay.distance(distance)
         let formattedDate = FormatDisplay.date(run.timestamp)
         let formattedTime = FormatDisplay.time(seconds)
         let formattedPace = FormatDisplay.pace(distance: distance,
                                                seconds: seconds,
                                                outputUnit: UnitSpeed.minutesPerMile)
         
         DistanceView.text = "Distance:  \(formattedDistance)"
         DateView.text = formattedDate
         TimeView.text = "Time:  \(formattedTime)"
         PaceView.text = "Pace:  \(formattedPace)"
        
    }

}
