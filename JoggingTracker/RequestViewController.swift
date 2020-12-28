//
//  RequestViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit
import FirebaseAuth
import CoreLocation

class RequestViewController: UIViewController, WebSocketConnectionDelegate {
    var socket: NativeWebSocket?
    var requestID = ""
    let currentUser = (Auth.auth().currentUser?.uid)!
    
    @IBAction func AcceptButton(_ sender: Any) {
        let regToken = UserDefaults.standard.object(forKey: "regToken") as? String
        let currentUser = (Auth.auth().currentUser?.uid)!
        let regTokenToSend = self.requestID
        var locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
            socket?.delegate = self
            socket?.send(text: "AcceptLock:"+String(currentLocation.coordinate.latitude)+"xN2.;Mlkd,0qD\"wPa_]Ne>}:uHlN9)jf"+"_"+String(currentLocation.coordinate.longitude)+"[>Susnt27hfINdn,xjU0&[6ejvZ_;\"P"+"...."+String(currentUser)+"fff"+regToken!+"vvv"+regTokenToSend)
        }
    }
    @IBAction func DeclineButton(_ sender: Any) {
        let regToken = UserDefaults.standard.object(forKey: "regToken") as? String
        let currentUser = (Auth.auth().currentUser?.uid)!
        let regTokenToSend = self.requestID
        socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
        socket?.delegate = self
        socket?.send(text: "Declino:xN2.;Mlkd,0qD\"wPa_]Ne>}:uHlN9)jf"+"[>Susnt27hfINdn,xjU0&[6ejvZ_;\"P"+"...."+String(currentUser)+"fff"+regToken!+"vvv"+regTokenToSend)
    }
    @IBAction func RequestButton(_ sender: Any) {
        let alert = UIAlertController(title: "Send Joggin Request?", message: "Do you want to jog with her or not.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let regTokenToSend = self.requestID
            let regToken = UserDefaults.standard.object(forKey: "regToken") as? String
            self.socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
            self.socket?.delegate = self
            self.socket?.send(text: "JogReq:P7vS2;9,iMt_b!uQ6%+TK%=..1Qh#5Rva]"+self.currentUser+"CuBN=]p6F3bZ5:WdVuK;BQJf1DN"+"..."+regTokenToSend+"<>"+regToken!)
            print("Request sent!")
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! ViewController
            self.present(nextViewController, animated:true, completion:nil)
        }))

        self.present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
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
