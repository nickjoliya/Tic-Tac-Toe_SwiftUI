//
//  ContentView.swift
//  Tik-Tak-Toe
//
//  Created by Jalpa on 10/09/24.
//
import SwiftUI

enum Difficulty: String, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case impossible = "Impossible"
}

struct ContentView: View {
    @State private var gameState = TicTacToeGameState()
    @State private var difficulty = Difficulty.impossible
    @State private var showDifficultyPicker = false

    var body: some View {
        ZStack {
            Color(.systemGray6).edgesIgnoringSafeArea(.all) // Background Color

            VStack(spacing: 10) {
                // Game Grid
                VStack(spacing: 10) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<3) { column in
                                Button(action: {
                                    _ = makeMove(gameState: &gameState, row: row, column: column, difficulty: difficulty)
                                    lightHaptic()
                                }) {
                                    cellView(row: row, column: column)
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                .shadow(radius: 10)

                // Game Over and Restart
                if gameState.gameOver {
                    VStack {
                        Text(gameState.winner != nil ? "Winner: \(gameState.winner!)" : "Draw!")
                            .font(.system(size: 30, weight: .bold))
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.green, Color.blue]), startPoint: .leading, endPoint: .trailing)
                                    .cornerRadius(15)
                            )
                            .foregroundColor(.white)
                            .animation(.easeInOut(duration: 0.5), value: gameState.gameOver)

                        Button(action: {
                            resetGame(gameState: &gameState)
                            heavyHaptic()
                        }) {
                            Text("Start over")
                                .font(.system(size: 25, weight: .bold))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .gray, radius: 4, x: 0, y: 4)
                        }
                        .padding(.top, 30)
                    }
                    .padding(.horizontal, 40)
                }
            }

            // Difficulty Button
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            showDifficultyPicker.toggle()
                        }
                    }) {
                        Text("Complexity")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 0, y: 4)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()

            // Difficulty Picker Modal
            if showDifficultyPicker {
                VStack(spacing: 10) {
                    Text("Select difficulty")
                        .font(.title)
                        .padding()

                    Picker("Complexity:", selection: $difficulty) {
                        ForEach(Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    Button(action: {
                        withAnimation {
                            showDifficultyPicker.toggle()
                        }
                    }) {
                        Text("Close")
                            .font(.system(size: 20, weight: .bold))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 4, x: 0, y: 4)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 20).fill(Color.white).shadow(radius: 10))
                .padding(.horizontal, 40)
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }
        }
    }

    func cellView(row: Int, column: Int) -> some View {
        let isInWinningLine = gameState.winningLine?.contains(where: { $0 == (row, column) }) ?? false
        let cellColor = isInWinningLine ? Color.yellow : Color.white
        
        return ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(cellColor)
                .frame(width: 80, height: 80)
                .shadow(color: .gray, radius: 2, x: 0, y: 2)

            Text(gameState.board[row][column])
                .font(.system(size: 50, weight: .bold))
                .foregroundColor(gameState.board[row][column] == "X" ? Color.blue : Color.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
