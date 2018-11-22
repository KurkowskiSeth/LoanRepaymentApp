//
//  LoansVC_TableView_EXT.swift
//  Repayment Plan
//
//  Created by Seth Kurkowski on 11/19/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit

// MARK: TableViewDataSource
extension LoansViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mLoans.count
        } else if section == 1 {
            return 0
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoanCell", for: indexPath)
        
        cell.textLabel?.text = mLoans[indexPath.row].name
        cell.detailTextLabel?.text = String(format: "$%.2f", mLoans[indexPath.row].amount)
        
        if mLoans[indexPath.row].paid {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var loanTotal: Double = 0
        for loan in mLoans {
            loanTotal = loanTotal + loan.amount
        }
        
        if section == 0 {
            return String(format: "Total: $%.02f", loanTotal)
        } else {
            return String(format: "Next Loan Payment: $%.02f", loanTotal * 0.01)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteLoanFromFirebase(at: mLoans[indexPath.row].key)
            mLoans.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
