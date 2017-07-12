//
//  FirstViewController.swift
//  Lyrica
//
//  Created by Nathan Lewis on 7/10/17.
//  Copyright © 2017 Nathan Lewis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fontPicker: UIPickerView!
    @IBOutlet weak var textEditor: UITextView!
    @IBOutlet weak var lineNumber: UITextView!
    @IBOutlet weak var sizePicker: UIPickerView!
    
    var lineNos = 1
    var textString = "1"
    var wholeText = ""
    let sizes = [12,13,14,15,16,17,18,19,20]
    let fonts = ["Helvetica Neue","Times New Roman","Courier New","Arial"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textEditor.delegate = self
        lineNumber.delegate = self
        sizePicker.delegate = self
        sizePicker.dataSource = self
        fontPicker.delegate = self
        fontPicker.dataSource = self
        
        let borderColor : UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textEditor.layer.borderWidth = 0.5
        textEditor.layer.borderColor = borderColor.cgColor
        textEditor.layer.cornerRadius = 5.0
        
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
        
        for text in wholeText.characters{
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == sizePicker{
            return sizes.count
        }
        else{
            return fonts.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == sizePicker{
            return String(sizes[row])
        }
        else{
            return fonts[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textEditor.font = UIFont.init(name: fonts[row], size: CGFloat(sizes[row]))
        lineNumber.font = UIFont.init(name: fonts[row], size: CGFloat(sizes[row]))
    }

}

