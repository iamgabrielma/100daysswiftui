//
//  ContentView.swift
//  BetterRest
//
//  Created by Gabriel Maldonado Almendra on 4/7/21.
//

import SwiftUI

struct ContentView: View {
    
    //@State private var wakeUp = Date()
    @State private var wakeUp = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeUpTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedTime() {
        // model will read our data and output a prediction using our ML model:
        let model = SleepCalculator() //Instance of our ml model
        
        // wakeUp represents the number of seconds but this property is a Date(), not a Double, so we need to convert this first:
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        // Now we feed the data to the ML model:
        do{
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short

            alertMessage = formatter.string(from: sleepTime)
            alertTitle = "Your ideal bedtime is…"
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Something went wrong."
        }
        
        showingAlert = true
    }
    
    var body: some View {
        NavigationView{
            Form{
                VStack{
                    Text("When do you want to wake up?").font(.headline)
                    DatePicker("Enter a time:", selection: $wakeUp, displayedComponents: .hourAndMinute).labelsHidden().datePickerStyle(WheelDatePickerStyle())
                }
                VStack{
                    Text("Desired amount of sleep:").font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25){
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                VStack{
                    Text("Daily coffee intake").font(.headline)
                    Stepper(value: $coffeeAmount, in: 1...20, step: 1){
                        if coffeeAmount == 1{
                            Text("1 cup")
                        } else {
                            Text("\(coffeeAmount) cups")
                        }
                    }
                }
            }.navigationBarTitle("BetterRest")
            .navigationBarItems(trailing:
                                    Button(action: calculateBedTime){ Text("Calculate!")}
            )
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
