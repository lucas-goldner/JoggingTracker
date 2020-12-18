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
        getApiResponse()
        OutputView.text = "jo"
        // Do any additional setup after loading the view.
    }
    
    struct Todo: Codable {
        let userID, id: Int
        let title: String
        let completed: Bool

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case id, title, completed
        }
    }
    
    func getApiResponse() {
        let urlString = "https://jsonplaceholder.typicode.com/todos/1"
               guard let url = URL(string: urlString) else {return}
               URLSession.shared.dataTask(with: url) { (data, res, error) in
           
                   do {
                       let todoDetails = try JSONDecoder().decode(Todo.self, from: data!)
                       DispatchQueue.main.async {
                 
                        self.OutputView.text = todoDetails.title
                        self.OutputView.text.append(" "+String(todoDetails.userID))
                        self.OutputView.text.append(" "+String(todoDetails.completed))
                       }
                   } catch {}
               }.resume()
           }
    
    }

