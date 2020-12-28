//
//  RequestViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit

class RequestViewController: UIViewController {
    
    @IBAction func AcceptButton(_ sender: Any) {
        let alert = UIAlertController(title: "Did you bring your towel?", message: "It's recommended you bring your towel before continuing.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    @IBAction func DeclineButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
