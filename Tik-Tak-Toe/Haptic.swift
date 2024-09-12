//
//  Haptic.swift
//  Tik-Tak-Toe
//
//  Created by Jalpa on 11/09/24.
//
import Foundation
import UIKit

func lightHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .light)
    generator.impactOccurred()
}

func mediumHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .medium)
    generator.impactOccurred()
}

func heavyHaptic() {
    let generator = UIImpactFeedbackGenerator(style: .heavy)
    generator.impactOccurred()
}
