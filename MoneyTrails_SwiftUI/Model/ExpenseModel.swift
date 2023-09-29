//
//  ExpenseModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-24.
//

import Foundation

struct Expense: Identifiable, Hashable {
    var id: String
    var title: String
    var amount: String
    var date: Date
    var category: String
    var userID: String
    
    init(id: String, title: String, category: String, amount: String, date: Date, userID: String) {
            self.id = id
            self.title = title
            self.category = category
            self.amount = amount
            self.date = date
            self.userID = userID
        }
}
