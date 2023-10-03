//
//  ContentView.swift
//  DeepLinkSwiftUI
//
//  Created by Chhan Sophearith on 3/10/23.
//

import SwiftUI

struct ContentView: View {

    /// We store the opened recipe name as a state property to redraw our view accordingly.
    @State private var openedDeepLinkName: String? {
        didSet {
            isPayment = self.openedDeepLinkName == "payment" ? true : false
            isNotification = self.openedDeepLinkName == "notification" ? true : false
        }
    }
    @State var isPayment = false
    @State var isNotification = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, Deeplink!")
                
                if let openedDeepLinkName {
                    Text("Opened Deeplink: \(openedDeepLinkName)")
                    if openedDeepLinkName == "payment" {
                        
                    }
                    
                    NavigationLink("", isActive: $isPayment) {
                        PaymentView()
                    }
                    
                    NavigationLink("", isActive: $isNotification) {
                        NotificationView()
                    }
                }
            }
            .padding()
                /// Responds to any URLs opened with our app. In this case, the URLs
                /// defined inside the URL Types section.
            .onOpenURL { incomingURL in
                print("App was opened via URL: \(incomingURL)")
                handleIncomingURL(incomingURL)
            }
        }
    }

    /// Handles the incoming URL and performs validations before acknowledging.
    private func handleIncomingURL(_ url: URL) {
        guard url.scheme == "deeplinkapp" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            print("Invalid URL")
            return
        }

        guard let action = components.host, action == "open-deeplink-app" else {
            print("Unknown URL, we can't handle this one!")
            return
        }

        guard let recipeName = components.queryItems?.first(where: { $0.name == "name" })?.value else {
            print("Deeplink name not found")
            return
        }

        openedDeepLinkName = recipeName
    }
}

#Preview {
    ContentView()
}
