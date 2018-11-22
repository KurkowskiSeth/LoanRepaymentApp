//
//  FirstViewController.swift
//  Repayment Plan
//
//  Created by Seth Kurkowski on 11/13/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoansViewController: UITableViewController {
    
    // MARK: Member Variables
    var mNewLoan: (name: String, amt: Double, tS: String) = ("", 0, "")
    var mRef: DatabaseReference!
    var mLoans: [Loan]!
    
    // MARK: Database Constants
    let CONST_LOANS = "loans"
    let CONST_NAME = "name"
    let CONST_AMOUNT = "amount"
    let CONST_PAID = "paid"
    let CONST_TIMESTAMP = "timestamp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mRef = Database.database().reference()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        pullLoansFromFirbase()
    }
    
    @IBAction func unwindToLoans(_ sender: UIStoryboardSegue) {
        // Save Loan to firebase
        saveLoanToFirebase()
    }
    
    func saveLoanToFirebase() {
        let key = mRef.child(CONST_LOANS).childByAutoId().key
        mRef.child(CONST_LOANS).child(key).setValue([
            CONST_NAME: mNewLoan.name,
            CONST_AMOUNT: mNewLoan.amt,
            CONST_TIMESTAMP: mNewLoan.tS,
            CONST_PAID: false])
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
                    else {print("Error Code: 0001"); return}
                    
                    self.mLoans.append(Loan(key: key, name: name, amount: amount, paid: paid, timestamp: timestamp))
                }
                
                // Sort array of loans
                self.mLoans.sort(by: { (loanA, loanB) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "y-MM-dd HH:mm:ss +0000"
                    guard let dateA = dateFormatter.date(from: loanA.timestamp),
                    let dateB = dateFormatter.date(from: loanB.timestamp)
                        else {print("Error Code: 0002"); return false}
                    
                    if dateA > dateB {
                        return false
                    } else {
                        return true
                    }
                })
                
                self.tableView.reloadData()
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func deleteLoanFromFirebase(at key: String) {
        mRef.child(CONST_LOANS).child(key).removeValue()
    }
}

struct Loan {
    var key: String
    var name: String
    var amount: Double
    var paid: Bool
    var timestamp: String
}
