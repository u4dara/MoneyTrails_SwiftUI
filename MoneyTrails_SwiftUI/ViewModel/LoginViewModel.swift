//
//  LoginViewModel.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-04.
//

import Foundation
import SwiftUI

class LoginViewModel : ObservableObject {
    
    @Published var name : String = ""
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var confirmPassword : String = ""
    
    @Published var showLoginView : Bool = false
    @Published var showSignupView : Bool = false
   
    
}
