//
//  CreateAccountView.swift
//  WeatherMonitor
//
//  Created by James Kowalski on 6/15/24.
//

import SwiftUI
import FirebaseAuth
struct AccountView: View {
    @AppStorage("uid") var userID: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        ZStack{
            
            //Gradient background
            BackgroundView()
            
            
            VStack{
                
                //Weather Monitor title
                HStack{
                    Text ("Weather Monitor")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    
                }
                .padding(.top) //Pad the top of the view to get it off the notch
                
                Image(systemName: "cloud.sun.fill")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                
                
                    
                
                //Email field
                EmailFieldView(email: $email)
                
                
                //Password field
                PasswordFieldView(password: $password)
                
                
                //Create account button
                Button{
                    //This creates a new account with the FireBase auth
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error=error {
                            print (error)
                            return
                        }
                        
                        //Check to see if the authorization succeeded.
                        if let authResult = authResult
                        {
                            userID = authResult.user.uid
                            
                        }
                    }
                    
                } label: {
                    Text("Create New Account")
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.blue)
                            
                            
                        )
                        .padding(.horizontal)
                    
                }
                .padding(.top)
                
                //Todo: This will take the user to the login screen
                
                Button(action: {
                    //                    withAnimation
                    //                    {
                    //                        self.currentShowingView = "login"
                    //                    }
                }, label: {
                    Text("Already have an account?")
                        .foregroundColor(.black.opacity(0.8))
                })
                Spacer()
                
            }
            
            
        }
    }
    

    

    
}

#Preview {
    AccountView()
}

struct EmailFieldView: View {
    @FocusState private var isEmailFieldFocused: Bool
    @Binding var email: String
    var body: some View {
        HStack{
            Image(systemName: "mail")
            ZStack(alignment: .leading){
                if email.isEmpty
                {
                    Text("Enter Email")
                        .foregroundColor(isEmailFieldFocused ?  .white: Color(UIColor.lightText) )
                }
                TextField("", text: $email)
                    .foregroundColor(.white)
                    .keyboardType(.emailAddress)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .focused($isEmailFieldFocused)
                
            }
            Spacer()
            
            //If the number of letters typed into the email
            //TextField is greater than zero validate.
            if (email.count != 0) {
                Image(systemName: isValidEmail(email) ? "checkmark" : "xmark")
                    .foregroundColor(isValidEmail(email) ? .blue : .red)
                
            }
        }
        .foregroundColor(.white)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: isEmailFieldFocused ? 3 : 2)
                .foregroundColor(.blue)
            
        )
        .padding()
    }
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct PasswordFieldView: View {
    @Binding var password: String
    @State private var isPasswordVisible: Bool = false
    @FocusState private var isPasswordFieldFocused: Bool
    var body: some View {
        HStack{
            Image(systemName: "lock")
            ZStack(alignment: .leading){
                if password.isEmpty
                {
                    Text("Enter Password")
                        .foregroundColor(isPasswordFieldFocused ?  .white: Color(UIColor.lightText) )
                }
                
                SecureField("", text: $password)
                    .foregroundColor(.white)
                    .keyboardType(.default)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .disableAutocorrection(true)
                    .focused($isPasswordFieldFocused)
                
                
                
                
            }
            Spacer()
            if (password.count != 0)
            {
                Button(
                    action: {
                        isPasswordVisible.toggle()
                    }
                )
                {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.blue) }
                Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                    .foregroundColor(isValidPassword(password) ? .blue : .red)
                
            }
        }
        .foregroundColor(.white)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: isPasswordFieldFocused ? 3 : 2)
                .foregroundColor(.blue)
        )
        .padding()
    }
    private func isValidPassword(_ pasword: String) -> Bool
    {
        // minimum 6 characters long
        // 1 upercase character
        // 1 special character
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        
        return passwordRegex.evaluate(with: password)
    }
}

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue,  Color("lightBlue")]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}
