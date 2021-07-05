//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by Gabriel Maldonado Almendra on 3/7/21.
//

import SwiftUI

struct ContentView: View {
    
    let possibilities = ["Rock", "Paper", "Scissors"]
    var machineChoice = Int.random(in: 0...2)
    
    @State private var machine = ""
    @State private var machineScore = 0
    @State private var player = ""
    @State private var playerScore = 0
    @State private var showingAlert = false
    
    func machineChooses(choice : Int) -> String{
        machine = possibilities[choice]
        return machine
    }
    
    func playerChooses(choice : Int) -> String{
        switch choice {
        case 0:
            //player = 0
        player = possibilities[choice]
        case 1:
            player = possibilities[choice]
        case 2:
            player = possibilities[choice]
        default:
            return player
        }
        return player
    }
    
    func playerScores() -> Int{
        
        return 0
    }
    
    func winsOrLosses(playerChoice: String, machineChoice: String) -> Text{

        var winOrLose = "_"

        if (player == "Rock" && machine == "Scissors") || (player == "Paper" && machine == "Rock") || player == "Scissors" && machine == "Paper"  {
            winOrLose = "Win"
            playerScore += 1
        } else if(player == machine){
            winOrLose = "Tie"
        } else {
            winOrLose = "Lose"
            machineScore += 1
        }
        
        let _s = Text("You choose \(player), Machine choose \(machine).\n You \(winOrLose)")
        return _s
    }
    
    var body: some View {
        VStack{
            Text("Player Score: \(playerScore)").font(.largeTitle)
            Text("Machine Score: \(machineScore)").font(.title3)
            Text("Select Rock, Paper, or Scissors:").padding()
        
            ForEach(0 ..< 3) { number in
                Button(action: {
                    self.machineChooses(choice: machineChoice)
                    self.playerChooses(choice: number) // This changes player state upon clicking
                    self.winsOrLosses(playerChoice: player, machineChoice: machine)
                    self.showingAlert = true
                }) {
                    Text(possibilities[number]).font(.largeTitle).padding()
                }
            }.alert(isPresented: $showingAlert) {
                Alert(title: Text("Title"), message: winsOrLosses(playerChoice: player, machineChoice: machine), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
