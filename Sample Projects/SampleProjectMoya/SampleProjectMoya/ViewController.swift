//
//  ViewController.swift
//  SampleProjectMoya
//
//  Created by Lee Nam Jun on 2021/07/14.
//

import UIKit
import Moya

class ViewController: UIViewController {
    @IBOutlet var jokeTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let provider = MoyaProvider<JokeAPI>()
        provider.request(.randomJokes("GilDong", "Hong")) { (result) in
            switch result {
            case let .success(response):
                let result = try? response.map(Joke.self)
                self.jokeTextView.text = result?.value.joke
            case let .failure(error):
                print(error.localizedDescription)
            }
            
        }
    }
}

struct Joke: Decodable {
    var type: String
    var value: Value

    struct Value: Decodable {
        var id: Int
        var joke: String
    }
}
