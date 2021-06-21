//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Lee Nam Jun on 2021/06/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var nounTextField: UITextField!
    @IBOutlet var adjectiveTextField: UITextField!
    @IBOutlet var verbTextField: UITextField!
    @IBOutlet var numberSlider: UISlider!
    @IBOutlet var numberLabel: UILabel!
    
    let storyPrompt = StoryPromptEntry()
    
    @IBAction func changeNumber(_ sender: UISlider) {
        numberLabel.text = "Number: \(Int(sender.value))"
        storyPrompt.number = Int(sender.value)
    }
    
    @IBAction func changeStoryType(_ sender: UISegmentedControl) {
        if let genre = StoryPrompts.Genre(rawValue: sender.selectedSegmentIndex) {
            storyPrompt.genre = genre
        } else {
            storyPrompt.genre = .scifi
        }
    }
    @IBAction func generateStoryPrompt(_ sender: Any) {
        updateStoryPrompt()
        print(storyPrompt)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        numberSlider.value = 7.5
        storyPrompt.noun = "toaster"
        storyPrompt.adjective = "smelly"
        storyPrompt.verb = "burps"
        storyPrompt.number = Int(numberSlider.value)
        print(storyPrompt)
        
        nounTextField.delegate = self
        verbTextField.delegate = self
        adjectiveTextField.delegate = self
    }
    
    func updateStoryPrompt() {
        storyPrompt.noun = nounTextField.text ?? ""
        storyPrompt.verb = verbTextField.text ?? ""
        storyPrompt.adjective = adjectiveTextField.text ?? ""
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateStoryPrompt()
        return true
    }
}
