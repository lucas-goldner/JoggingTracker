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
    
    struct Demon: Codable {
        let level: Int
        let name, id, weakness, strength, imun, absorb, reflect: String


        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name, level, weakness, strength, imun, absorb, reflect
        }
    }
    
   
    
    func getApiResponse() {
        let urlString = "http://159.69.196.125:4220/api/demons/1"
               guard let url = URL(string: urlString) else {return}
               URLSession.shared.dataTask(with: url) { (data, res, error) in
           
                   do {
                       let demonDetails = try JSONDecoder().decode(Demon.self, from: data!)
                       DispatchQueue.main.async {
                 
                        self.OutputView.text = demonDetails.name
                       }
                   } catch {}
               }.resume()
           }
    
    }

