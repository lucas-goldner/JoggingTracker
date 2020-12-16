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
        
  
        DateView.text = formattedDate
        TimeView.text = "\(formattedTime)"
        PaceView.text = "\(formattedPace)"
        loadMap()
    }
    
    private func loadMap() {
      guard
        let locations = run.locations,
        locations.count > 0,
        let region = mapRegion()
      else {
          let alert = UIAlertController(title: "Error",
                                        message: "Sorry, this run has no locations saved",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .cancel))
          present(alert, animated: true)
          return
      }
        
    }
    
    

}
