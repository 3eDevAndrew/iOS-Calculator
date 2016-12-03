//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Andrew Vasquez on 7/14/16.
//  Copyright © 2016 3E Development, LLC. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    private var internalProgram = [AnyObject]()
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations : Dictionary <String, Operation> = [
        "π": Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√": Operation.UnaryOperation(sqrt), // sqrt()
        "cos": Operation.UnaryOperation(cos), //cos()
        "sin": Operation.UnaryOperation(sin), //cos()
        "tan": Operation.UnaryOperation(tan), //cos()
        //these are called closures----  here --
        "+": Operation.BinaryOperation({$0+$1}), // x + y
        "×": Operation.BinaryOperation({$0*$1}), //x * y
        "÷": Operation.BinaryOperation({$0/$1}), // x - y
        "-": Operation.BinaryOperation({$0-$1}), //x - y
        "=": Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String) {
        
        internalProgram.append(symbol)
        
        if let operation = operations[symbol]{
            switch operation{
            case .Constant(let associatedConstantValue):
                accumulator = associatedConstantValue
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingCaculcations()
                pending = PendingBinaryOperationInfo(binaryFunction: function,  firstOperand: accumulator)
            case .Equals:
                executePendingCaculcations()
                
            }
        }
    }
    
    private func executePendingCaculcations() {
        if pending != nil{
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending : PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: ((Double, Double) -> Double)
        var firstOperand: (Double)
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get{
            return internalProgram
        }
        set{
            clear()
            if let arrOfOps = newValue as? [AnyObject] {
                for op in arrOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    }
                    else if let operation = op as? String {
                        performOperation(operation)
                    }
                    
                }
            
            }
        }
    }
    
    func clear(){
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    
}