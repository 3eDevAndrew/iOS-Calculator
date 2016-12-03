//
//  ViewController.swift
//  Calculator
//
//  Created by Andrew Vasquez on 7/13/16.
//  Copyright © 2016 3E Development, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!
    //regular property
    
    private var userIsInTheMiddleOfTyping: Bool = false
    private var usingDecimalPlace: Bool = false
    private var decimalPlace = 0.1
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        //constant property
        let digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        
        if userIsInTheMiddleOfTyping
        {
            if usingDecimalPlace {
                displayValue = displayValue + decimalPlace*Double(digit)!
                decimalPlace = decimalPlace*0.1
            }
            else{
                display.text = textCurrentlyInDisplay + digit
                
            }
        }
        else
        {
            display.text = digit
        }
        
        userIsInTheMiddleOfTyping = true
        
    }
    
    @IBAction private func touchDecimal() {
        usingDecimalPlace = true
    }
    
    //computed property
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            //newValue is the Double passed in
            display.text = String(newValue)
        }
    }
    
    
    let brain: CalculatorBrain = CalculatorBrain()
    
    @IBAction private func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
        }
        
        userIsInTheMiddleOfTyping = false
        usingDecimalPlace = false
        decimalPlace = 0.1
        
        if let mathematicalSymbol = sender.currentTitle{
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
}

