//
//  ContentView.swift
//  WordScramble
//
//  Created by Gabriel Maldonado Almendra on 4/7/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    // Better error handling:
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    func addNewWord(){
        // lowercase and trim, to assure there's no duplicates with different casing
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        // checks that it has at least 1 character otherwise exit
        guard answer.count > 0 else {
            return
        }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            return
        }
        //Insert that word at position 0 in the usedWords array and set newWord back to be an empty string
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame(){
        // Find the URL data source in our bundle
        if let startWordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            // Load the txt file
            if let startWords = try? String(contentsOf: startWordsURL){
                // Split the string into an array
                let allWords = startWords.components(separatedBy: "\n")
                // Pick a random one, or default to "silkworm"
                rootWord = allWords.randomElement() ?? "silkworm"
                // If all is good, return
                return
            }
        }
        // Something went wrong loading the data source:
        fatalError("Could not load words.txt from bundle.")
    }
    // return true or false depending on whether the word has been used before or not
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    // checks whether a random word can be made out of the letters from another random word.
    func isPossible(word: String) -> Bool {
        
        var tempWord = word
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    // In order to bridge Swift strings to Objective-C strings safely, we need to create an instance of NSRange using the UTF-16 count of our Swift string
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    var body: some View {
        NavigationView{
            VStack{
                TextField("Enter your word:", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                
                List(usedWords, id: \.self){
                    Image(systemName: "\($0.count).circle") // Apple’s SF Symbols icons
                    Text($0)
                }
            }.navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
