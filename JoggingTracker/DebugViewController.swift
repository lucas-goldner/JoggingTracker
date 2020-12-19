//
//  DebugViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 14.12.20.
//

import UIKit
import Starscream

class DebugViewController: UIViewController, WebSocketDelegate {
     var socket: WebSocket!
     var isConnected = false
     let server = WebSocketServer()
    @IBOutlet weak var OutputView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "http://localhost:8080")!) //https://localhost:8080
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    
}

