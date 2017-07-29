//
//  CalculatorController.swift
//  Calculator
//
//  Created by Collin Cannavo on 7/17/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import Foundation

class CalculatorController {
    
    static let shared = CalculatorController()
    
    func calculate(price: Double, moneyDown: Double, interest: Double, months: Double, tradeValue: Double) -> Double {
        
        let subtotal = (price + 299.00) - moneyDown - tradeValue
        let tax = subtotal * 0.0685
        let subtotalTax = subtotal + tax
        let includedInterest = subtotalTax * interest
        let total = includedInterest + subtotal
        let monthlyPayment = total / months
        
        return monthlyPayment
        
        
    }
    
    func creditScoreLookup(input: Int) -> Double {
        
        switch input {
        case 0...599:
            return 0.083
        case 600...649:
            return 0.062
        case 650...699:
            return 0.0431
        case 700...749:
            return 0.03919
        case 750...850:
            return 0.03697
        default:
            print("Entry out of bounds. Please enter a number between 0 and 850")
        }
        
        return Double(input)
    }
  
}
