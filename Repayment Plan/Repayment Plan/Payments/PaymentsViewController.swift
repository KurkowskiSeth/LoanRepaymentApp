//
//  SecondViewController.swift
//  Repayment Plan
//
//  Created by Seth Kurkowski on 11/13/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PaymentsViewController: UITableViewController {
    
    // MARK: Member Variables
    var mNewPayment: (date: String, amt: Double, tS: String) = ("", 0, "")
    var mRef: DatabaseReference!
    var mPayments: [Payment]!
    var mLoans: [Loan]!
    
    // MARK: Database Constants
    let CONST_PAYMENTS = "payments"
    let CONST_DATE = "date"
    let CONST_AMOUNT = "amount"
    let CONST_TIMESTAMP = "timestamp"
    let CONST_LOANS = "loans"
    let CONST_NAME = "name"
    let CONST_PAID = "paid"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mRef = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pullPaymentsFromFirebase()
    }
    
    @IBAction func unwindToPayments(_ sender: UIStoryboardSegue) {
        // Save Loan to firebase
        savePaymentToFirebase()
    }
    
    func savePaymentToFirebase() {
        let key = mRef.child(CONST_PAYMENTS).childByAutoId().key
        mRef.child(CONST_PAYMENTS).child(key).setValue([
            CONST_DATE: mNewPayment.date,
            CONST_AMOUNT: mNewPayment.amt,
            CONST_TIMESTAMP: mNewPayment.tS])
        
        pullLoansFromFirbase()
    }
    
    func subtractFromLoans() {
        var paymentAmountLeft = mNewPayment.amt
        
        for loan in mLoans {
            if !loan.paid {
                if paymentAmountLeft > 0 {
                    let newLoanAmount = loan.amount - paymentAmountLeft
                    if newLoanAmount < 0 {
                        paymentAmountLeft = newLoanAmount * -1
                        // Update Firebase loan amount
                        updateLoanAmount(at: loan.key, with: 0, paidOff: true)
                    } else if newLoanAmount == 0 {
                        paymentAmountLeft = 0
                        
                        // Update Firebase loan amount
                        updateLoanAmount(at: loan.key, with: newLoanAmount, paidOff: true)
                    } else {
                        paymentAmountLeft = 0
                        
                        // Update Firebase loan amount
                        updateLoanAmount(at: loan.key, with: newLoanAmount, paidOff: false)
                    }
                }
            }
        }
    }
    
    func updateLoanAmount(at key: String, with amount: Double, paidOff: Bool) {
        mRef.child(CONST_LOANS).child(key).child(CONST_AMOUNT).setValue(amount)
        if paidOff {
            mRef.child(CONST_LOANS).child(key).child(CONST_PAID).setValue(paidOff)
        }
    }
    
    func pullPaymentsFromFirebase() {
        mPayments = [Payment]()
        
        mRef.child(self.CONST_PAYMENTS).observeSingleEvent(of: .value) { (snapshot) in
            if let payments = snapshot.value as? NSDictionary {
                for payment in payments {
                    guard let paymentDetails = payment.value as? Dictionary<String, Any>,
                        let amount = paymentDetails[self.CONST_AMOUNT] as? Double,
                        let date = paymentDetails[self.CONST_DATE] as? String,
                        let timestamp = paymentDetails[self.CONST_TIMESTAMP] as? String
                        else {print("Error Code 0003"); return}
                    
                    self.mPayments.append(Payment(date: date, amount: amount, timestamp: timestamp))
                }
                
                // Sort array of payments
                self.mPayments.sort(by: { (paymentA, paymentB) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "y-MM-dd HH:mm:ss +0000"
                    guard let dateA = dateFormatter.date(from: paymentA.timestamp),
                        let dateB = dateFormatter.date(from: paymentB.timestamp)
                        else {print("Error Code: 0002"); return false}
                    
                    if dateA > dateB {
                        return false
                    } else {
                        return true
                    }
                })
                
                self.tableView.reloadData()
            }
        }
    }
    
    func pullLoansFromFirbase() {
        mLoans = [Loan]()
        
        mRef.child(CONST_LOANS).observeSingleEvent(of: .value, with: { (snapshot) in
            if let loans = snapshot.value as? NSDictionary {
                for loan in loans {
                    guard let key = loan.key as? String,
                        let loanDetails = loan.value as? Dictionary<String, Any>,
                        let amount = loanDetails[self.CONST_AMOUNT] as? Double,
                        let name = loanDetails[self.CONST_NAME] as? String,
                        let paid = loanDetails[self.CONST_PAID] as? Bool,
                        let timestamp = loanDetails[self.CONST_TIMESTAMP] as? String
                        else {print("Error Code: 0004"); return}
                    
                    self.mLoans.append(Loan(key: key, name: name, amount: amount, paid: paid, timestamp: timestamp))
                }
            }
            
            self.subtractFromLoans()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

struct Payment {
    var date: String
    var amount: Double
    var timestamp: String
}
