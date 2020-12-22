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
        let pseudoJson = "{type:message , data:{time:1472513071731,text:😍,author:iPhone Simulator,color:orange}}"
        socket?.send(text: pseudoJson)
    
        //socket?.send(text: "Mother")
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
    
    func jsonToData(json: Any) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    func dataToJSON(data: Data) -> Any? {
       do {
           return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
       } catch let myJSONError {
           print(myJSONError)
       }
       return nil
    }
}

