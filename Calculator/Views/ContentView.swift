//
//  ContentView.swift
//  CatsApp
//
//  Created by Ekaterina Smolyakova on 13/02/2024.
//

import SwiftUI
import Observation

struct ContentView: View {
    @State var viewModel = ContentViewModel()
    
    func buttonWidth(fromScreenWidth width: CGFloat) -> CGFloat {
        (width - 5 * 8) / 4
    }
    
    func calculatorButton(proxy: GeometryProxy, style: ButtonStyle, content: ButtonContent, size: ButtonSize = .short, action: @escaping () -> Void = {}) -> CalculatorButton {
        CalculatorButton(style: style, width: buttonWidth(fromScreenWidth: proxy.size.width), content: content, size: size, action: action)
    }
    
    func calculatorButton(proxy: GeometryProxy, style: ButtonStyle, text: String, size: ButtonSize = .short, action: @escaping () -> Void = {}) -> CalculatorButton {
        calculatorButton(proxy: proxy, style: style, content: .string(text), size: size, action: action)
    }
    
    func calculatorButton(proxy: GeometryProxy, style: ButtonStyle, symbolName: String, size: ButtonSize = .short, action: @escaping () -> Void = {}) -> CalculatorButton {
        calculatorButton(proxy: proxy, style: style, content: .symbolName(symbolName), size: size, action: action)
    }
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(viewModel.outputText).multilineTextAlignment(.trailing).frame(height: 50).foregroundStyle(Color.white).font(.system(size: 50, weight: .light))
                }
                .padding()
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                
                HStack {
                    calculatorButton(proxy: proxy, style: .lightGray, text: "C") {
                        viewModel.onClearTapped()
                    }
                    calculatorButton(proxy: proxy, style: .lightGray, symbolName: "plus.forwardslash.minus") {
                        viewModel.onSignChangeTapped()
                    }
                    calculatorButton(proxy: proxy, style: .lightGray, symbolName: "percent") {
                        viewModel.onPercentTapped()
                    }
                    calculatorButton(proxy: proxy, style: .orange, symbolName: "divide") {
                        viewModel.onOperationTapped(operation: .divide)
                    }
                }
                HStack {
                    calculatorButton(proxy: proxy, style: .gray, text: "7") {
                        viewModel.onDigitTapped(number: 7)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: "8") {
                        viewModel.onDigitTapped(number: 8)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: "9") {
                        viewModel.onDigitTapped(number: 9)
                    }
                
                    calculatorButton(proxy: proxy, style: .orange, symbolName: "multiply") {
                        viewModel.onOperationTapped(operation: .multiply)
                    }
                }
                HStack {
                    calculatorButton(proxy: proxy, style: .gray, text: "4") {
                        viewModel.onDigitTapped(number: 4)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: "5") {
                        viewModel.onDigitTapped(number: 5)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: "6") {
                        viewModel.onDigitTapped(number: 6)
                    }
                    calculatorButton(proxy: proxy, style: .orange, symbolName: "minus") {
                        viewModel.onOperationTapped(operation: .subtract)
                    }
                }
                HStack {
                    calculatorButton(proxy: proxy, style: .gray, text: "1") {
                        viewModel.onDigitTapped(number: 1)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: "2") {
                        viewModel.onDigitTapped(number: 2)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: "3") {
                        viewModel.onDigitTapped(number: 3)
                    }
                    calculatorButton(proxy: proxy, style: .orange, symbolName: "plus") {
                        viewModel.onOperationTapped(operation: .add)
                    }
                }
                HStack {
                    calculatorButton(proxy: proxy, style: .gray, text: "0", size: .long) {
                        viewModel.onDigitTapped(number: 0)
                    }
                    calculatorButton(proxy: proxy, style: .gray, text: viewModel.separator) {
                        viewModel.onDecimalSeparatorTapped()
                    }
                    calculatorButton(proxy: proxy, style: .orange, symbolName: "equal") {
                        viewModel.onEqualTapped()
                    }
                }
            }.frame(maxHeight: .infinity)
        }.padding()
            .background(Color.black)
    }
}


#Preview {
    VStack {
        ContentView()
    }
}
