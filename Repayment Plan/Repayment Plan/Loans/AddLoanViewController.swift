//
//  AddLoanViewController.swift
//  Repayment Plan
//
//  Created by Seth Kurkowski on 11/19/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit

class AddLoanViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: Member Variables
    var mName = ""
    var mAmount: Double = 0
    var mNameValid = false
    var mAmountValid = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        nameTF.resignFirstResponder()
        amountTF.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! LoansViewController
        destination.mNewLoan = (mName, mAmount, Date.init().description)
    }
}

extension AddLoanViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTF {
            if let name = textField.text {
                if name.count > 0 {
                    mName = name
                    mNameValid = true
                }
            }
        }
        if textField == amountTF {
            if let amountString = textField.text {
                if let amountDouble = Double(amountString) {
                    if amountDouble > 0 {
                        mAmount = amountDouble
                        mAmountValid = true
                    }
                }
            }
        }
        
        if mNameValid && mAmountValid {
            saveBtn.isEnabled = true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
