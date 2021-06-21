//
//  ViewController.swift
//  StoryPrompt
//
//  Created by Lee Nam Jun on 2021/06/21.
//

import UIKit
import PhotosUI

class ViewController: UIViewController {
    
    @IBOutlet var nounTextField: UITextField!
    @IBOutlet var adjectiveTextField: UITextField!
    @IBOutlet var verbTextField: UITextField!
    @IBOutlet var numberSlider: UISlider!
    @IBOutlet var storyPromptImageView: UIImageView!
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
        if storyPrompt.isValid() {
            print(storyPrompt)
        } else {
            let alert = UIAlertController(title: "Invalid Story Prompt", message: "Please fill out of all the fields", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { action in
                
            })
            alert.addAction(action)
            present(alert, animated: true)
        }
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
        
        storyPromptImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        storyPromptImageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func updateStoryPrompt() {
        storyPrompt.noun = nounTextField.text ?? ""
        storyPrompt.verb = verbTextField.text ?? ""
        storyPrompt.adjective = adjectiveTextField.text ?? ""
    }
    
    @objc func changeImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = self
        present(controller, animated: true)
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateStoryPrompt()
        return true
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if !results.isEmpty {
            let result = results.first!
            let provider = result.itemProvider
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let image = image as? UIImage else {
                        return
                    }
                    DispatchQueue.main.async {
                        self!.storyPromptImageView.image = image
                    }
                }
            }
        }
    }
}
