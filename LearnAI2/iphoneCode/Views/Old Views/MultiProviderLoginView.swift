////
////  MultiProviderLoginView.swift
////  ReMEMq
////
////  Created by Sehaj Singh on 2/5/25.
////
//import SwiftUI
////import GoogleSignIn
//
//
//struct MultiProviderLoginView: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            AppleSignInButtonView()  // Our custom Apple Sign In view
//            
//            Button("Sign in with Google") {
//                signInWithGoogle()
//            }
//            .frame(height: 45)
//            .background(Color.red)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//            
//            Button("Sign in with Facebook") {
//                signInWithFacebook()
//            }
//            .frame(height: 45)
//            .background(Color.blue)
//            .foregroundColor(.white)
//            .cornerRadius(8)
//        }
//        .padding()
//    }
//    
//
//
//    func signInWithGoogle() {
//////        guard let clientID = FirebaseApp.app()?.options.clientID else { return } // if using Firebase; otherwise, use your clientID
////        let signInConfig = GIDConfiguration(clientID: clientID)
//////        
////        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: UIApplication.shared.windows.first!.rootViewController!) { user, error in
////            if let error = error {
////                print("Google Sign In error: \(error.localizedDescription)")
////                return
////            }
////            // Retrieve the Google ID token
////            guard let idToken = user?.authentication.idToken else { return }
////            // Send idToken to your backend
////            sendGoogleTokenToBackend(idToken)
//        }
//    
//
//    func sendGoogleTokenToBackend(_ token: String) {
//        // Use URLSession or your networking library to send the token to your backend.
//    }
//    
//    func signInWithFacebook() {
//        // Use Facebook Login SDK to sign in.
//    }
//}
//
//
//#Preview{
//    MultiProviderLoginView()
//}
