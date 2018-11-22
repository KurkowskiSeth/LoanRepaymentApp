//
//  AddPaymentViewController.swift
//  Repayment Plan
//
//  Created by Seth Kurkowski on 11/19/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit

class AddPaymentViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var dateDP: UIDatePicker!
    @IBOutlet weak var amountTF: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: Member Variables
    var mDate = "NO DATE"
    var mAmount: Double = 0
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        amountTF.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! PaymentsViewController
        destination.mNewPayment = (mDate, mAmount, Date.init().description)
    }
}

extension AddPaymentViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == amountTF {
            if let amountString = textField.text {
                if let amountDouble = Double(amountString) {
                    if amountDouble > 0 {
                        mAmount = amountDouble
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMMM dd, yyyy"
                        mDate = dateFormatter.string(from: dateDP.date)
                        saveBtn.isEnabled = true
                    }
                }
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
