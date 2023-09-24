//
//  ExpenseModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-24.
//

import Foundation

struct Expense {
    var id: String?
    var expenseName: String
    var amount: Double
    var date: Date
    var category: Category
    var userID: String
}
