//
//  CalculatorButton.swift
//  Calculator
//
//  Created by Ekaterina Smolyakova on 19/02/2024.
//

import SwiftUI

enum ButtonStyle {
    case orange
    case gray
    case lightGray
}

enum ButtonSize {
    case short
    case long
}

enum ButtonContent {
    case string(String)
    case symbolName(String)
}

struct CalculatorButton: View {
    let style: ButtonStyle
    let width: CGFloat
    let content: ButtonContent
    let size: ButtonSize
    let action: () -> Void
    
    init(style: ButtonStyle, width: CGFloat, content: ButtonContent, size: ButtonSize = .short, action: @escaping () -> Void = {}) {
        self.style = style
        self.width = width
        self.content = content
        self.size = size
        self.action = action
    }
    
    var longSizeWidth: CGFloat {
        width * 2 + 8
    }
    
    var alignment: Alignment {
        switch size {
        case .short:
            return .center
        case .long:
            return .leading
        }
    }
    
    
    var backgroundColor: Color {
        switch style {
        case .gray:
            return Color(white: 0.2)
        case .orange:
            return .orange
        case .lightGray:
            return Color(white: 0.8)
        }
    }
    
    var foregroundColor: Color {
        switch style {
        case .orange:
            return .white
        case .gray:
            return .white
        case .lightGray:
            return .black
        }
    }
        
    var body: some View {
        Button(action: action, label: {
            switch size {
            case .short:
                switch content {
                case .string(let string):
                    Text(string)
                        .frame(width: width, height: width, alignment: .center)
                        .background(backgroundColor)
                        .clipShape(Capsule())
                        .foregroundStyle(foregroundColor)
                        .font(.title)
                case .symbolName(let symbolName):
                    Image(systemName: symbolName)
                        .frame(width: width, height: width, alignment: .center)
                        .background(backgroundColor)
                        .clipShape(Capsule())
                        .foregroundStyle(foregroundColor)
                        .font(.title)
                }
            case .long:
                ZStack {
                    switch content {
                    case .string(let string):
                        Text(string)
                            .frame(width: width, height: width)
                    case .symbolName(let symbolName):
                        Image(systemName: symbolName)
                            .frame(width: width, height: width)
                    }
                }.frame(width: longSizeWidth, height: width, alignment: .leading)
                    .background(backgroundColor)
                    .clipShape(Capsule())
                    .foregroundStyle(foregroundColor)
                    .font(.title)
            }
        })
        
    }
}
