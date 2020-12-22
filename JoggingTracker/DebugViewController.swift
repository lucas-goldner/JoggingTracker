//
//  DebugViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 14.12.20.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SwiftyJSON

class DebugViewController: UIViewController, WebSocketConnectionDelegate {
    var isConnected = false
    let db = Firestore.firestore()
    var socket: NativeWebSocket?
   
    @IBOutlet weak var OutputView: UITextView!
    @IBOutlet weak var SendView: UITextView!
    @IBOutlet weak var ConnectView: UIButton!
    @IBOutlet weak var EmailView: UITextView!
    @IBOutlet weak var PasswordView: UITextView!
    @IBAction func LoginButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: EmailView.text, password: PasswordView.text) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
        }
    }
    @IBAction func SendButton(_ sender: Any) {
        let json = "{ \"location\": [{ \"timestamp\": \"10:00\", \"latitude\": \"45\", \"longitude\": 30 }, { \"timestamp\": \"12:00\", \"latitude\": \"12\", \"longitude\": 12 }, { \"timestamp\": \"22:00\", \"longitude\": \"10\", \"longitude\": 5 } ] }"
        if let data = json.data(using: .utf8) {
            if let json = try? JSON(data: data) {
                socket?.send(data: data)
            }
        }
        socket?.send(text: "Mother")
    
    }
    @IBAction func LoadButton(_ sender: Any) {
        getUserInfo()
    }
    @IBAction func ConnectButton(_ sender: UIBarButtonItem) {
        if isConnected {
            ConnectView.setTitle("Connect", for: .normal)

        } else {
            ConnectView.setTitle("Disconnect", for: .normal)

        }
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
               self.SendView.text.append("\(text)\n")
           }
       }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
        socket?.delegate = self
    }

  
    
    func getUserInfo() {
        let userID = Auth.auth().currentUser?.uid
        print(userID)
        let docRef = db.collection("users").document(userID!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }
}

