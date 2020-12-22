//
//  NewRunViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit
import CoreLocation
import Firebase

class NewRunViewController: UIViewController, WebSocketConnectionDelegate {
    var isConnected = false
    let db = Firestore.firestore()
    var socket: NativeWebSocket?
    
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
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
          self.eachSecond()
        }
        startLocationUpdates()
        
        //Websocket
        socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
        socket?.delegate = self
        getUserInfo()
        sendDataToServer()
    }
    
    func getUserInfo() {
        let userID = Auth.auth().currentUser?.uid
        let docRef = db.collection("users").document(userID!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print(document.get("friends"))
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func sendDateToServer() {
        
    }
    
    private func stopRun() {
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { [self] _ in
            self.StartButtonStyle.isHidden = false
            self.StopStyle.isHidden = true
            self.locationManager.stopUpdatingLocation()
            self.saveRun()
            self.sendToResult()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            self.StartButtonStyle.isHidden = true
            self.StopStyle.isHidden = false
        })
        present(alertController, animated: true)
    }
    
    func sendToResult() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "doneRun") as! RunsListViewController
        nextViewController.run = run
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startUpdatingLocation()
    }
    
    private func saveRun() {
      let newRun = Run(context: CoreDataStack.context)
      newRun.distance = distance.value
        newRun.duration = Int16(seconds)
      newRun.timestamp = Date()
      
      for location in locationList {
        let locationObject = Location(context: CoreDataStack.context)
        locationObject.timestamp = location.timestamp
        locationObject.latitude = location.coordinate.latitude
        locationObject.longitude = location.coordinate.longitude
        newRun.addToLocations(locationObject)
      }
      
      CoreDataStack.saveContext()
      
      run = newRun
        
    }
    
    func onConnected(connection: WebSocketConnection) {
           print("Connected!")
       }
       
       func onDisconnected(connection: WebSocketConnection, error: Error?) {
           print("Disconnected!")
       }
       
       func onError(connection: WebSocketConnection, error: Error) {
           print("Error \(error)")
       }
       
       func onMessage(connection: WebSocketConnection, text: String) {
           DispatchQueue.main.async {
               //self.SendView.text.append("\(text)\n")
           }
       }

}

extension NewRunViewController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }

      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
      }

      locationList.append(newLocation)
    }
  }
}

