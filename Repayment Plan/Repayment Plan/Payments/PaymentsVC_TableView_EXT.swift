//
//  PaymentsVC_TableView_EXT.swift
//  Repayment Plan
//
//  Created by Seth Kurkowski on 11/20/18.
//  Copyright © 2018 Seth Kurkowski. All rights reserved.
//

import UIKit

extension PaymentsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mPayments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath)
        
        cell.textLabel?.text = mPayments[indexPath.row].date
        cell.detailTextLabel?.text = String(format: "$%.2f", mPayments[indexPath.row].amount)
        
        return cell
    }
    
}
