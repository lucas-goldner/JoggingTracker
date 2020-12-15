//
//  NewRunViewController.swift
//  JoggingTracker
//
//  Created by Lucas Goldner on 15.12.20.
//

import UIKit

class NewRunViewController: UIViewController {
    @IBOutlet weak var StartButtonStyle: UIButton!
    @IBAction func StartButton(_ sender: Any) {
        startRun()
    }
    @IBOutlet weak var StopStyle: UIButton!
    @IBAction func StopButton(_ sender: Any) {
        stopRun()
    }
    private var run: Run?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StartButtonStyle.isHidden = false
        StopStyle.isHidden = true
    }
    
    private func startRun() {
        StartButtonStyle.isHidden = true
        StopStyle.isHidden = false
    }
    
    private func stopRun() {
        StartButtonStyle.isHidden = false
        StopStyle.isHidden = true
        let alertController = UIAlertController(title: "End run?",
                                                message: "Do you wish to end your run?",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            self.sendToResult()
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
          self.stopRun()
          _ = self.navigationController?.popToRootViewController(animated: true)
        })
            
        present(alertController, animated: true)
        
       
    }
    
    func sendToResult() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "doneRun") as! RunsListViewController
        nextViewController.run = run
        self.present(nextViewController, animated:true, completion:nil)
    }

}

