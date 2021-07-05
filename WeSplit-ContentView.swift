//
//  ContentView.swift
//  WeSplit
//
//  Created by Gabriel Maldonado Almendra on 1/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var checkAmount = ""
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 2
    //@State private var totalBill = 0
    
    let tipPercentages = [0, 10, 15, 20]
    
    var totalPerPerson : Double {
        
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    var totalBill : Double {
        
        return totalPerPerson * Double(numberOfPeople)
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Enter amount:", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    Picker("Number of folks:", selection: $numberOfPeople ){
                        ForEach(2..<100) {_ in
                            Text("\(numberOfPeople) people")
                        }
                    }.keyboardType(.alphabet)
                }
                Section(header: Text("How much do you want to tip?")){
                    Picker("Tip %", selection: $tipPercentage){
                        ForEach(0 ..< tipPercentages.count){
                            Text("\(self.tipPercentages[$0])%")
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Amount per person:")){
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
                Section(header: Text("Total Bill:")){
                    Text("\(totalBill, specifier: "%.2f")").font(.largeTitle)
                }
            }
        }.navigationTitle("WeSplit")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
