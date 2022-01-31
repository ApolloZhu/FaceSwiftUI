//
//  ContentView.swift
//  Shared
//
//  Created by Apollo Zhu on 1/30/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Face()
            .stroke(lineWidth: 5)
            .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
        ContentView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
