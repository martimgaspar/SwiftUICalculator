//
//  ContentView.swift
//  SwiftUICalculator
//
//  Created by Martim Gaspar on 9/15/23.
//

import SwiftUI

struct ContentView: View {
    
    let grid = [
        ["AC", "⌦", "%", "/"], //⌦ 2326
        ["7", "8", "9", "X"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        [".", "0", "", "="]
    ]
    
    let operators = ["/", "+", "%", "X", "="]
    
    @State var visibleWorkings = ""
    @State var visibleResults = ""
    @State var showAlert = false
    
    var body: some View {
        VStack {
            HStack{ //workings
                Spacer()
                Text(visibleWorkings)
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(size: 30, weight: .heavy))
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{ //result
                Spacer()
                Text(visibleResults)
                    .padding()
                    .foregroundColor(Color.white)
                    .font(.system(size: 50, weight: .heavy))
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ForEach(grid, id: \.self)
            {
                row in
                HStack
                {
                    ForEach(row, id: \.self)
                    {
                        cell in
                        
                        Button(action: { buttonPressed(cell: cell)}, label: {
                            Text(cell)
                                .foregroundColor(buttonColor(cell))
                                .font(.system(size: 40, weight: .heavy))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        })
                        
                    }
                }
            }
            
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    
    func buttonColor(_ cell: String) -> Color {
        
        if(cell == "AC" || cell == "⌦") {
            return .red
        }
        if (cell == "-" || operators.contains(cell)){
            return .orange
        }
        
        return .white
    }
    
    func buttonPressed(cell: String){
        switch cell {
        case "AC":
            visibleResults = ""
            visibleWorkings = ""
        case "⌦":
            visibleWorkings = String(visibleWorkings.dropLast())
        case "=":
            visibleResults = calculateResults()
        default:
            visibleWorkings += cell
        }
    }
    
    func addOperator(_ cell : String)
        {
            if !visibleWorkings.isEmpty
            {
                let last = String(visibleWorkings.last!)
                if operators.contains(last)
                {
                    visibleWorkings.removeLast()
                }
                visibleWorkings += cell
            }
        }
        
        func addMinus()
        {
            if visibleWorkings.isEmpty || visibleWorkings.last! != "-"
            {
                visibleWorkings += "-"
            }
        }
        
        func calculateResults() -> String
        {
            if(validInput())
            {
                var workings = visibleWorkings.replacingOccurrences(of: "%", with: "*0.01")
                workings = workings.replacingOccurrences(of: "X", with: "*")
                let expression = NSExpression(format: workings)
                let result = expression.expressionValue(with: nil, context: nil) as! Double
                return formatResult(val: result)
            }
            showAlert = true
            return ""
        }
        func validInput() -> Bool
        {
            if(visibleWorkings.isEmpty)
            {
                return false
            }
            let last = String(visibleWorkings.last!)
            
            if(operators.contains(last) || last == "-")
            {
                if(last != "%" || visibleWorkings.count == 1)
                {
                    return false
                }
            }
            
            return true
        }
        
        func formatResult(val : Double) -> String
        {
            if(val.truncatingRemainder(dividingBy: 1) == 0)
            {
                return String(format: "%.0f", val)
            }
            
            return String(format: "%.2f", val)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
