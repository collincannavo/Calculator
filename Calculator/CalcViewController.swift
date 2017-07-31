//
//  CalcViewController.swift
//  Calculator
//
//  Created by Collin Cannavo on 7/18/17.
//  Copyright © 2017 Collin Cannavo. All rights reserved.
//

import UIKit

class CalcViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    // Add a scroll view so people can scroll down to enter their information
    
    @IBOutlet weak var monthlyPaymentLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var interestRateLabel: UILabel!
    @IBOutlet weak var creditScoreTextField: UITextField!
    @IBOutlet weak var enterCreditScoreLabel: UILabel!
    @IBOutlet weak var enterTradeValueLabel: UILabel!
    @IBOutlet weak var lengthOfLoanTextField: UITextField!
    @IBOutlet weak var downPaymentTextField: UITextField!
    @IBOutlet weak var vehiclePriceTextField: UITextField!
   
    @IBAction func dealershipFeeDetails(_ sender: Any) {
        feeDetails()
    }
    @IBAction func clearButtonTapped(_ sender: Any) {
        creditScoreTextField.text = ""
        lengthOfLoanTextField.text = ""
        downPaymentTextField.text = ""
        vehiclePriceTextField.text = ""
        tradeValueTextField.text = ""
        monthlyPaymentLabel.text = "$000"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpButtons()
        setupConstraints()
    }

    let calculateButton = UIButton()
    let tradeValueTextField = UITextField()
    let backgroundColorView = UIView()
    
    func calculateButtonTapped(_ sender: UIButton) -> Double {
        
        let paymentText = downPaymentTextField.text?.components(separatedBy: ",").joined().components(separatedBy: .symbols).joined()
        let loanLength = lengthOfLoanTextField.text?.components(separatedBy: ",").joined().components(separatedBy: .symbols).joined()
        let price = vehiclePriceTextField.text?.components(separatedBy: ",").joined().components(separatedBy: .symbols).joined()
        let trade = tradeValueTextField.text?.components(separatedBy: ",").joined().components(separatedBy: .symbols).joined()
        
        guard let lengthOfLoan = loanLength.flatMap({Double($0)}),
            let downPayment = paymentText.flatMap({ Double($0)}),
            let vehiclePrice = price.flatMap({Double($0)}),
            let tradeValue = trade.flatMap({Double($0)})
            else { return 0 }
        
        
        guard let interestPercentage = creditScoreTextField.text.flatMap ({ Int($0.trimmingCharacters(in: .whitespaces)) }) else { return 0 }
        
        let interest = CalculatorController.shared.creditScoreLookup(input: interestPercentage)
        
        let monthlyPayment = CalculatorController.shared.calculate(price: vehiclePrice, moneyDown: downPayment, interest: interest, months: lengthOfLoan, tradeValue: tradeValue)
    
        let formatter = NumberFormatter()
        
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        if let formattedTipAmount = formatter.string(from: monthlyPayment as NSNumber) {
            monthlyPaymentLabel.text = "\(formattedTipAmount)"
        }
        
        return monthlyPayment
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func feeDetails() {
        
        let alertController = UIAlertController(title: "Dealership Fee", message: "Dealerships will charge a fee to pay for processing paperwork, bank fees, and employee salaries. Each state will charge a different fee (e.g. $299 in Utah, $349 in New Mexico, etc.).", preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertController.addAction(okayAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        print("Button pressed")
        
    }

    func setUpButtons() {
        
        // Add targets to button
        view.addSubview(backgroundColorView)
        view.sendSubview(toBack: backgroundColorView)
        view.addSubview(calculateButton)
        view.addSubview(tradeValueTextField)
        calculateButton.addTarget(self, action: #selector(calculateButtonTapped(_:)), for: UIControlEvents.touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        
        backgroundColorView.backgroundColor = UIColor.backgroundColor
        calculateButton.backgroundColor = UIColor.calculateColor
        calculateButton.setTitleColor(UIColor.white, for: .normal)
        calculateButton.setTitle("Calculate", for: .normal)
        tradeValueTextField.layer.cornerRadius = 5.0
        tradeValueTextField.placeholder = "Trade In Value"
        tradeValueTextField.textAlignment = .center
        tradeValueTextField.backgroundColor = .white
        tradeValueTextField.textColor = UIColor(red: 39 / 255.0, green: 19 / 255.0, blue: 166 / 255.0, alpha: 1.0)
        tradeValueTextField.font = UIFont.init(name: "Arial", size: 20)
        tradeValueTextField.delegate = self
        calculateButton.titleLabel?.font = UIFont.init(name: "Marker Felt", size: 33)
        
    }
    
    func setupConstraints() {
        
        calculateButton.translatesAutoresizingMaskIntoConstraints = false
        tradeValueTextField.translatesAutoresizingMaskIntoConstraints = false
        backgroundColorView.translatesAutoresizingMaskIntoConstraints = false
        
        // Height and Width Constraints
        
        let backgroundColorViewWidth = NSLayoutConstraint(item: backgroundColorView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0)
        let backgroundColorViewHeight = NSLayoutConstraint(item: backgroundColorView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1.0, constant: 0)
        let calculateButtonWidths = NSLayoutConstraint(item: calculateButton, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0)

        
        // Leading and trailing constraints
        
        let calculateButtonLeadingConstraints = NSLayoutConstraint(item: calculateButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0)
        let calculateButtonTrailingConstraints = NSLayoutConstraint(item: calculateButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: 0)
        let tradeValueTextFieldLeadingConstraints = NSLayoutConstraint(item: tradeValueTextField, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 38)
        let tradeValueTextFieldTrailingConstraints = NSLayoutConstraint(item: tradeValueTextField, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: -38)
        
        // Top and Bottom constraints

        let calculateButtonBottomConstraints = NSLayoutConstraint(item: calculateButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
        let calculateButtonTopContraints = NSLayoutConstraint(item: calculateButton, attribute: .top, relatedBy: .equal, toItem: tradeValueTextField, attribute: .bottom, multiplier: 1.0, constant: 20)
        let tradeValueTextFieldTopConstraint = NSLayoutConstraint(item: tradeValueTextField, attribute: .top, relatedBy: .equal, toItem: enterTradeValueLabel, attribute: .bottom, multiplier: 1.0, constant: 8)
        
        view.addConstraints([calculateButtonWidths,
                             backgroundColorViewWidth,
                             backgroundColorViewHeight,
                             calculateButtonLeadingConstraints,
                             calculateButtonBottomConstraints,
                             calculateButtonTrailingConstraints,
                             calculateButtonTopContraints,
                             tradeValueTextFieldLeadingConstraints,
                             tradeValueTextFieldTrailingConstraints,
                             tradeValueTextFieldTopConstraint
                            ])
        
    }
   

}
