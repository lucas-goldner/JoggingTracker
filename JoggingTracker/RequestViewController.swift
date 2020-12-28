//
//  RequestViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit
import FirebaseAuth


class RequestViewController: UIViewController, WebSocketConnectionDelegate {
    var socket: NativeWebSocket?
    
    @IBAction func AcceptButton(_ sender: Any) {
    }
    @IBAction func DeclineButton(_ sender: Any) {
    }
    @IBAction func RequestButton(_ sender: Any) {
        let alert = UIAlertController(title: "Send Joggin Request?", message: "Do you want to jog with her or not.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let currentUser = (Auth.auth().currentUser?.uid)!
            self.socket = NativeWebSocket(url: URL(string: "ws://localhost:1337")!, autoConnect: true)
            self.socket?.delegate = self
            self.socket?.send(text: "JogReq:P7vS2;9,iMt_b!uQ6%+TK%=..1Qh#5Rva]"+currentUser+"CuBN=]p6F3bZ5:WdVuK;BQJf1DN")
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
