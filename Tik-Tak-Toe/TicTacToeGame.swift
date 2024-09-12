//
//  TicTacToeGame.swift
//  Tik-Tak-Toe
//
//  Created by Jalpa on 11/09/24.
//

import Foundation

struct TicTacToeGameState {
    var board: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    var currentPlayer: String = "X"
    var gameOver: Bool = false
    var winner: String? = nil
    var winningLine: [(Int, Int)]? = nil
    var difficulty: Difficulty = .medium
}

func makeMove(gameState: inout TicTacToeGameState, row: Int, column: Int, difficulty: Difficulty) -> Bool {
    // Проверяем, окончена ли игра
    if gameState.gameOver {
        return false
    }
    if gameState.board[row][column] == "" {
        gameState.board[row][column] = gameState.currentPlayer
        
        let checkResult = checkWinner(gameState: gameState)
        
        if checkResult.0 == gameState.currentPlayer {
            gameState.gameOver = true
            gameState.winner = gameState.currentPlayer
            gameState.winningLine = checkResult.1
        } else if gameState.board.joined().contains("") {
            gameState.currentPlayer = gameState.currentPlayer == "X" ? "O" : "X"
            if gameState.currentPlayer == "O" {
                gameState.difficulty = difficulty
                let move: (Int, Int)? = computerMove(gameState: &gameState, difficulty: difficulty)
                if let move = move {
                    _ = makeMove(gameState: &gameState, row: move.0, column: move.1, difficulty: difficulty)
                    mediumHaptic()
                }
            }
        } else {
            gameState.gameOver = true
        }
        
        return true
    }
    
    return false
}


func checkWinner(gameState: TicTacToeGameState) -> (String?, [(Int, Int)]?) {
    // Проверка горизонталей
    for row in 0..<3 {
        if let player = gameState.board[row].first, player != "", gameState.board[row].allSatisfy({ $0 == player }) {
            return (player, [(row, 0), (row, 1), (row, 2)])
        }
    }

    // Проверка вертикалей
    for column in 0..<3 {
        let player = gameState.board[0][column]
        if player != "" && (0..<3).allSatisfy({ gameState.board[$0][column] == player }) {
            return (player, [(0, column), (1, column), (2, column)])
        }
    }

    // Проверка диагоналей
    let topLeftPlayer = gameState.board[0][0]
    if topLeftPlayer != "" && (0..<3).allSatisfy({ gameState.board[$0][$0] == topLeftPlayer }) {
        return (topLeftPlayer, [(0, 0), (1, 1), (2, 2)])
    }

    let topRightPlayer = gameState.board[0][2]
    if topRightPlayer != "" && (0..<3).allSatisfy({ gameState.board[$0][2 - $0] == topRightPlayer }) {
        return (topRightPlayer, [(0, 2), (1, 1), (2, 0)])
    }

    // Проверка наличия пустых ячеек
    if gameState.board.flatMap({ $0 }).contains("") {
        return (nil, nil)
    }

    // В случае ничьей
    return ("Draw", nil)
}

func resetGame(gameState: inout TicTacToeGameState) {
    gameState.board = Array(repeating: Array(repeating: "", count: 3), count: 3)
    gameState.currentPlayer = "X"
    gameState.gameOver = false
    gameState.winner = nil
    gameState.winningLine = nil
    }

func randomMove(gameState: TicTacToeGameState) -> (Int, Int)? {
    var availableMoves: [(Int, Int)] = []
    for row in 0..<3 {
        for column in 0..<3 {
            if gameState.board[row][column] == "" {
                availableMoves.append((row, column))
            }
        }
    }
    return availableMoves.randomElement()
}

func computerMove(gameState: inout TicTacToeGameState, difficulty: Difficulty) -> (Int, Int)? {
    switch difficulty {
    case .easy:
        return randomMove(gameState: gameState)
    case .medium:
        return Bool.random() ? randomMove(gameState: gameState) : bestMove(gameState: &gameState, difficulty: difficulty)
    case .impossible:
        return bestMove(gameState: &gameState, difficulty: difficulty)
    }
}



func bestMove(gameState: inout TicTacToeGameState, difficulty: Difficulty) -> (Int, Int)? {
    var bestScore = Int.min
    var bestMove: (row: Int, column: Int)?

    for row in 0..<3 {
        for column in 0..<3 {
            if gameState.board[row][column] == "" {
                var newGameState = gameState
                newGameState.board[row][column] = "O"
                let score = minimax(gameState: newGameState, depth: 0, isMaximizing: false, alpha: Int.min, beta: Int.max, difficulty: difficulty)
                if score > bestScore {
                    bestScore = score
                    bestMove = (row, column)
                }
            }
        }
    }
    return bestMove
}

func minimax(gameState: TicTacToeGameState, depth: Int, isMaximizing: Bool, alpha: Int, beta: Int, difficulty: Difficulty) -> Int {
    let checkResult = checkWinner(gameState: gameState)
    let winner = checkResult.0
    
    if let winner = winner {
        if winner == "X" {
            return -10 + depth
        } else if winner == "O" {
            return 10 - depth
        } else {
            return 0
        }
    }

    if isMaximizing {
        var maxEval = Int.min
        var a = alpha
        for row in 0..<3 {
            for column in 0..<3 {
                if gameState.board[row][column] == "" {
                    var newGameState = gameState
                    newGameState.board[row][column] = "O"
                    let eval = minimax(gameState: newGameState, depth: depth + 1, isMaximizing: false, alpha: a, beta: beta, difficulty: difficulty)
                    maxEval = max(maxEval, eval)
                    a = max(a, eval)
                    if beta <= a {
                        break
                    }
                }
            }
        }
        return maxEval
    } else {
        var minEval = Int.max
        var b = beta
        for row in 0..<3 {
            for column in 0..<3 {
                if gameState.board[row][column] == "" {
                    var newGameState = gameState
                    newGameState.board[row][column] = "X"
                    let eval = minimax(gameState: newGameState, depth: depth + 1, isMaximizing: true, alpha: alpha, beta: b, difficulty: difficulty)
                    minEval = min(minEval, eval)
                    b = min(b, eval)
                    if b <= alpha {
                        break
                    }
                }
            }
        }
        return minEval
    }
}
