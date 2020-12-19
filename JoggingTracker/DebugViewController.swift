//
//  DebugViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 14.12.20.
//

import UIKit

class DebugViewController: UIViewController {

    @IBOutlet weak var OutputView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        OutputView.text = "jo"
    }
}

