//
//  ForgotPasswordView.swift
//  MoneyTrails_SwiftUI
//
//  Created by Udara Sachinthana on 2023-09-05.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @State private var email = ""
    
    var body: some View {
        ZStack{
            Color.white.ignoresSafeArea()
            
            VStack{
                // Gradiant Background
                LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                    .frame(height: 255)
                    .overlay{
                        VStack{
                            Image("ForgetPassword_Image").resizable()
                                .scaledToFit()
                                .frame(width: 350)
                        }
                    }
                
                VStack(spacing: 20){
                    
                    // Login Text
                    HStack{
                        Spacer()
                        Text("Forget Password").font(.system(size: 30, weight: .bold))
                        Spacer()
                    }
                    
                    // Instruction Text
                    Text("Please enter the email address associated with your account")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.center)
                    
                    // Email Textfield
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color("TextBackground"))
                        .frame(height: 50)
                        .shadow(color: .gray, radius: 1)
                        .padding(.vertical, 10)
                        .overlay{
                            HStack{
                                Image(systemName: "envelope").padding([.leading], 30).foregroundColor(.secondary)
                                TextField("Email", text: $email)
                            }
                        }
                    
                    
                    // Login Button
                    Button {
                        
                    } label: {
                        
                        ZStack {
                            LinearGradient(colors: [Color("COrange"), Color("CPurple")], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea(edges : .top).clipShape(RoundedRectangle(cornerRadius: 10))
                                .frame(height: 50)
                            Text("Reset Password")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .bold()
                        }.padding(.top, 10)
                        
                    }
                    
                    
                }.padding()
                
                
                
                Spacer()
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
