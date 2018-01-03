//
//  FirstViewController.swift
//  Lyrica
//
//  Created by Nathan Lewis on 7/10/17.
//  Copyright © 2017 Nathan Lewis. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class FirstViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var textEditor: UITextView!
    @IBOutlet weak var lineNumber: UITextView!
    @IBOutlet weak var currentWordLabel: UILabel!
    @IBOutlet weak var rhymesTextView: UITextView!
    
    var rhymeList = [RhymeDto]()
    var lineNos = 1
    var textString = "1"
    var wholeText = ""
    var currentWord = ""
    var rhymingWords = ""
    let fonts = ["Helvetica Neue","Times New Roman","Courier New","Arial"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEditor.delegate = self
        lineNumber.delegate = self
        fontPicker.delegate = self
        fontPicker.dataSource = self
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red:243/255, green:226/255, blue:172/255, alpha:1.0)]
        
        
        
        let borderColor : UIColor = UIColor(red: 53/255, green: 58/255, blue: 93/255, alpha: 1.0)
        textEditor.layer.borderWidth = 0.5
        textEditor.layer.borderColor = borderColor.cgColor
        textEditor.layer.cornerRadius = 5.0
        
        lineNumber.layer.cornerRadius = 2.5
        lineNumber.isEditable = false
        lineNumber.showsVerticalScrollIndicator = false
        lineNumber.showsHorizontalScrollIndicator = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == lineNumber{
            textEditor.contentOffset = lineNumber.contentOffset
        }
        if scrollView == textEditor{
            lineNumber.contentOffset = textEditor.contentOffset
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        lineNos = 1
        wholeText = textView.text!
        
        for text in wholeText{
            if text == "\n"{
                lineNos = lineNos + 1
                textString = ""
                for i in 1 ... lineNos{
                    textString = textString + "\(i)\n"
                }
            }
        }
        lineNumber.text = textString
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let myRange = Range<String.Index>(uncheckedBounds: (lower: textView.text.startIndex, upper: textView.text.index(textView.text.startIndex, offsetBy: range.location)))
        var subString = textView.text.substring(with: myRange)
        subString += text
        subString = subString.replacingOccurrences(of: "\n", with: " ", options: .regularExpression)
        print(subString)
        
        let wordArray = subString.components(separatedBy: " ")
        if let wordTyped = wordArray.last {
            if wordTyped != "" {
                currentWord = wordTyped
                print("word typed: " + wordTyped)
            }
        }
        
        currentWordLabel.text = currentWord
        getRhymes()
        
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return fonts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return fonts[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textEditor.font = UIFont.init(name: fonts[row], size: 14)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
    
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
        
            pickerLabel?.font = UIFont(name: "Montserrat", size: 16)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
    
        pickerLabel?.text = fonts[row]
    
        return pickerLabel!;
    }
    
    func getRhymes(){
        Alamofire.request("https://api.datamuse.com/words?rel_rhy="+currentWord, method: .get, parameters: ["":""], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    if let result = response.result.value {
                        let JSON = result as! NSArray
                        guard let rhymeResults = [RhymeDto].from(jsonArray: result as! [JSON]) else{
                            // handle decoding failure here
                            return
                        }
                        self.rhymeList = rhymeResults
                    }
                    
                    var rhymeWords = [String]()
                    for object in self.rhymeList {
                        rhymeWords.append(object.word!)
                    }
                    self.rhymesTextView.text = rhymeWords.joined(separator: ", ")
                }
            case .failure(_):
                print(response.result.error!)
                break
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navToRec"{
            let RecordNavigationController = segue.destination as! UINavigationController
            
            let RecordViewController = RecordNavigationController.topViewController as!RecordViewController
            
            RecordViewController.rapText = textEditor.text
        }
    }

}

