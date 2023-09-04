//
//  Onboarding.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-04.
//

import SwiftUI

struct Onboarding: View {
    
    @StateObject var loginVM : LoginViewModel = LoginViewModel()
    
    var body: some View {
        ZStack{
            Color.secondary.opacity(0.2).ignoresSafeArea()
            
            VStack{
                LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .overlay{
                        VStack(spacing: 50){
                            VStack{
                                Image("Onboarding_Image").resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                            }.padding(.bottom, 50)
                            
                            Text("Manage your finance anywhere, anytime.")
                                .foregroundColor(.white)
                                .font(.system(size: 28))
                                .multilineTextAlignment(.center)
                            
                            
                            VStack{
                                Button {
                                    loginVM.showLoginView = true
                                } label: {
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(Color("CBlue"))
                                            .frame(height: 50)
                                        Text("Login")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                            .bold()
                                    }.padding(.horizontal , 20)
                                }
                                
                                Button {
                                    loginVM.showSignupView = true
                                } label: {
                                    
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.white)
                                            .frame(height: 50)
                                        Text("Sign Up")
                                            .font(.system(size: 22))
                                            .foregroundColor(.black)
                                            .bold()
                                    }.padding(.horizontal , 20)
                                }
                            }
                            
                            
                            
                        }
                        
                    }
            }
        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
