//
//  CategoryViewModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-11.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class CategoryViewModel : ObservableObject {
    
    struct RGBColor {
        let red: Double
        let green: Double
        let blue: Double
    }
    
    func writeColorToFirestore(selectedColor: Color) {
        // Convert SwiftUI Color to RGB values
        let uiColor = UIColor(selectedColor)
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        // Create an instance of RGBColor
        let rgbColor = RGBColor(red: Double(red), green: Double(green), blue: Double(blue))
        
        let db = Firestore.firestore()
        let colorsCollection = db.collection("colors")
        
        let colorData = [
            "red": rgbColor.red,
            "green": rgbColor.green,
            "blue": rgbColor.blue
        ]
        
        colorsCollection.addDocument(data: colorData) { error in
            if let error = error {
                print("Error adding color: \(error.localizedDescription)")
            } else {
                print("Color added to Firestore successfully!")
            }
        }
    }
    
    
}
