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
    @IBOutlet weak var ConnectView: UIButton!
    @IBAction func ConnectButton(_ sender: UIBarButtonItem) {
        if isConnected {
            ConnectView.setTitle("Connect", for: .normal)
            socket.disconnect()
        } else {
            ConnectView.setTitle("Disconnect", for: .normal)
            socket.connect()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "ws://159.69.196.125:1337/")!) //https://localhost:5100
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
    }

    func didReceive(event: WebSocketEvent, client: WebSocket) {
          switch event {
          case .connected(let headers):
              isConnected = true
              print("websocket is connected: \(headers)")
            //OutputView.text = "websocket is connected: \(headers)"
          case .disconnected(let reason, let code):
              isConnected = false
              print("websocket is disconnected: \(reason) with code: \(code)")
          case .text(let string):
              print("Received text: \(string)")
          case .binary(let data):
              print("Received data: \(data.count)")
          case .ping(_):
              break
          case .pong(_):
              break
          case .viabilityChanged(_):
              break
          case .reconnectSuggested(_):
              break
          case .cancelled:
              isConnected = false
          case .error(let error):
              isConnected = false
              handleError(error)
          }
      }
    
    func handleError(_ error: Error?) {
          if let e = error as? WSError {
              print("websocket encountered an error: \(e.message)")
          } else if let e = error {
              print("websocket encountered an error: \(e.localizedDescription)")
          } else {
              print("websocket encountered an error")
          }
      }
}

