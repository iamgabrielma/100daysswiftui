//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Gabriel Maldonado Almendra on 3/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int .random(in: 0...2)
    
    func flagTapped(number: Int){
        if number == correctAnswer {
            scoreTitle = "Correct!"
            userScore += 1
        } else {
            scoreTitle = "Nope! That's the flag for \(countries[number])"
        }
        
        showingScore = true
    }
    
    func askQuestion(){
        countries.shuffle()
        correctAnswer = Int.random(in: 1...2)
    }
    
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                VStack{
                    Text("Tap the flag!").foregroundColor(.white)
                    Text(countries[correctAnswer]).foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3){ number in
                    Button(action: {
                        self.flagTapped(number: number)
                    }) {
                        Image(self.countries[number]).renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                }
                Spacer()
                Text("Score: \(userScore)").foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
        }
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text("Your score is: \(userScore) "), dismissButton: .default(Text("Contiue")){
                self.askQuestion()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
