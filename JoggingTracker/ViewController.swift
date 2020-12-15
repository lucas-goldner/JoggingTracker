//
//  ViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 14.12.20.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var Logo: UIImageView!
    @IBOutlet weak var GoRunButton: UIButton!
    @IBOutlet weak var OldRunsButton: UIButton!
    @IBOutlet weak var DebugButtonStyle: UIButton!
    @IBAction func GoRunAction(_ sender: Any) {
    }
    @IBAction func OldRunsAction(_ sender: Any) {
    }
    @IBAction func DebugButton(_ sender: Any) {
        hideRun()
    }
    let radius = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GoRunButton.layer.cornerRadius = CGFloat(radius)
        OldRunsButton.layer.cornerRadius = CGFloat(radius)
        DebugButtonStyle.layer.cornerRadius = CGFloat(radius)
    }

    func hideRun() {
        GoRunButton.isHidden = true
    }

}

