//
//  StoryPromptViewController.swift
//  StoryPrompt
//
//  Created by Lee Nam Jun on 2021/06/22.
//

import UIKit

class StoryPromptViewController: UIViewController {

    @IBOutlet var storyPromptTextView: UITextView!
    
    var storyPrompt: StoryPromptEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storyPromptTextView.text = storyPrompt?.description
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
