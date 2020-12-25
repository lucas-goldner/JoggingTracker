//
//  ViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 14.12.20.
//

import UIKit
import CoreLocation
import FirebaseAuth

class ViewController: UIViewController, WebSocketConnectionDelegate {
    var isConnected = false
    var socket: NativeWebSocket?
    
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var GoRunButton: UIButton!
    @IBOutlet weak var OldRunsButton: UIButton!
    @IBOutlet weak var DebugButtonStyle: UIButton!
    @IBAction func GoRunAction(_ sender: Any) {
    }
    @IBAction func OldRunsAction(_ sender: Any) {
    }
    @IBAction func DebugButton(_ sender: Any) {
    }
    let radius = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "regToken")
        print("Hier bro:"+token!)
        
//        var locManager = CLLocationManager()
//        locManager.requestWhenInUseAuthorization()
//        var currentLocation: CLLocation!
//        let currentUser = (Auth.auth().currentUser?.uid)!
//        if
//           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
//           CLLocationManager.authorizationStatus() ==  .authorizedAlways
//        {
//            currentLocation = locManager.location
//            print(currentLocation.coordinate.latitude)
//            print(currentLocation.coordinate.longitude)
//            socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
//            socket?.delegate = self
//            socket?.send(text: "Locasione:"+String(currentLocation.coordinate.latitude)+"xN2.;Mlkd,0qD\"wPa_]Ne>}:uHlN9)jf"+"_"+String(currentLocation.coordinate.longitude)+"[>Susnt27hfINdn,xjU0&[6ejvZ_;\"P"+"...."+String(currentUser))
//        }
        GoRunButton.layer.cornerRadius = CGFloat(radius)
        OldRunsButton.layer.cornerRadius = CGFloat(radius)
        DebugButtonStyle.layer.cornerRadius = CGFloat(radius)
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

