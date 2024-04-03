//
//  ContentViewModel.swift
//  Calculator
//
//  Created by Ekaterina Smolyakova on 19/02/2024.
//

import Foundation

enum CalculatorState {
    case initial
    case inputedOneNumber(String)
    case inputSecondNumber(String, CalculatorOperation, String)
    case result(String)
}

@Observable class ContentViewModel {
    private var calculatorState = CalculatorState.initial
    private let formatter = NumberFormatter()
    var separator: String {
        formatter.decimalSeparator
    }
    
    var outputText: String {
        switch calculatorState {
        case .initial:
            return "0"
        case .inputedOneNumber(let number):
            return number
        case .inputSecondNumber(let firstNumber, _, let secondNumber):
            if secondNumber.isEmpty {
                return firstNumber
            } else {
                return secondNumber
            }
        case .result(let string):
            return string
        }
    }
    
    init() {
        formatter.maximumFractionDigits = 5
    }
    
    func modifyStringWithDecimal(string: String) -> String {
        
        if !string.contains(separator) {
            return string + separator
        } else {
            return string
        }
    }
    
    func onDecimalSeparatorTapped() {
        switch calculatorState {
        case .initial:
            calculatorState = .inputedOneNumber("0\(separator)")
        case .inputedOneNumber(let string):
            calculatorState = .inputedOneNumber(modifyStringWithDecimal(string: string))
        case .inputSecondNumber(let firstNumber, let calculatorOperation, let secondNumber):
            calculatorState = .inputSecondNumber(firstNumber, calculatorOperation, modifyStringWithDecimal(string: secondNumber))
        case .result:
            calculatorState = .inputedOneNumber("0\(separator)")
        }
    }
    
    func onDigitTapped(number: Int) {
        print(number)
        switch calculatorState {
        case .initial:
            calculatorState = .inputedOneNumber(String(number))
        case .inputedOneNumber(let string):
            calculatorState = .inputedOneNumber(removeExtraZeroes(string: (string + String(number))))
        case .inputSecondNumber(let firstNumber, let operation, let secondNumber):
            calculatorState = .inputSecondNumber(firstNumber, operation, removeExtraZeroes(string: secondNumber + String(number)))
        case .result:
            calculatorState = .inputedOneNumber(String(number))
        }
    }
    
    func onClearTapped() {
        calculatorState = .initial
    }
    
    func removeExtraZeroes(string: String) -> String {
        if string.contains(separator) {
            return string
        }
        
        var string = string
        let isNegative: Bool
        
        if string.first == "-" {
            isNegative = true
            string = String(string.dropFirst())
        } else {
            isNegative = false
        }
        
        while string.count > 1 && string.first == "0" {
            string = String(string.dropFirst())
        }
        
        if isNegative {
            string = "-" + string
        }
        return string
    }
    
    func performOperation(firstNumber: String, operation: CalculatorOperation, secondNumber: String) -> String {
        guard !secondNumber.isEmpty else {
            return firstNumber
        }
        
        let firstNumberDouble = formatter.number(from: firstNumber)!.doubleValue
        let secondNumberDouble = formatter.number(from: secondNumber)!.doubleValue
        let result: Double
        
        //TODO: move it to model and figure out how to count in doubles
        switch operation {
        case .add:
            result = firstNumberDouble + secondNumberDouble
        case .divide:
            //TODO: forbid to divide on 0, show Error
            result = firstNumberDouble / secondNumberDouble
        case .multiply:
            result = firstNumberDouble * secondNumberDouble
        case .subtract:
            result = firstNumberDouble - secondNumberDouble
        }
        
        return formatDouble(stringDouble: result)
    }
    
    func formatDouble(stringDouble: Double) -> String {
        return formatter.string(from: NSNumber(value: stringDouble))!
    }
    
    
    func onOperationTapped(operation: CalculatorOperation) {
        switch calculatorState {
        case .initial:
            break
        case .inputedOneNumber(let string):
            calculatorState = .inputSecondNumber(string, operation, "")
        case .inputSecondNumber(let firstNumber, let oldOperation, let secondNumber):
            calculatorState = .inputSecondNumber(performOperation(firstNumber: firstNumber, operation: oldOperation, secondNumber: secondNumber), operation, "")
        case .result(let string):
            calculatorState = .inputSecondNumber(string, operation, "")
        }
    }
    
    func onSignChangeTapped() {
        switch calculatorState {
        case .initial:
            calculatorState = .inputedOneNumber("-0")
        case .inputedOneNumber(let string):
            calculatorState = .inputedOneNumber(signChange(string: string))
        case .inputSecondNumber(let firstNumber, let calculatorOperation, let secondNumber):
            if secondNumber.isEmpty {
                calculatorState = .inputSecondNumber(firstNumber, calculatorOperation, "-0")
            } else {
                calculatorState = .inputSecondNumber(firstNumber, calculatorOperation, signChange(string: secondNumber))
            }
        case .result(let string):
            calculatorState = .result(signChange(string: string))
        }
    }
    
    func signChange(string: String) -> String {
        if string.first == "-" {
            return String(string.dropFirst())
        } else {
            return "-\(string)"
        }
    }
    
    func onPercentTapped() {
        switch calculatorState {
        case .initial:
            break
        case .inputedOneNumber(let firstNumber):
            calculatorState = .result(performPercentOnSingleNumberOperation(string: firstNumber))
        case .inputSecondNumber(let firstNumber, _, let secondNumber):
            calculatorState = .result(performPercentOnTwoNumbersOperation(firstNumber: firstNumber, secondNumber: secondNumber))
        case .result(let string):
            calculatorState = .result(performPercentOnSingleNumberOperation(string: string))
        }
    }
    
    func performPercentOnSingleNumberOperation(string: String) -> String {
        let stringDouble = Double(string)!
        let percentageOfStringDouble = stringDouble / 100.0
        
        return formatDouble(stringDouble: percentageOfStringDouble)
    }
    
    func performPercentOnTwoNumbersOperation(firstNumber: String, secondNumber: String) -> String {
        let firstNumberDoublePercentage = formatter.number(from: performPercentOnSingleNumberOperation(string: firstNumber))!.doubleValue
        let secondNumberDouble = formatter.number(from: secondNumber)!.doubleValue
        
        
        return String(firstNumberDoublePercentage * secondNumberDouble)
        
    }
    
    func onEqualTapped() {
        switch calculatorState {
        case .initial:
            break
        case .inputedOneNumber:
            break
        case .inputSecondNumber(let firstNumber, let calculatorOperation, let secondNumber):
            calculatorState = .result(performOperation(firstNumber: firstNumber, operation: calculatorOperation, secondNumber: secondNumber))
        case .result:
            break
        }
    }
}
