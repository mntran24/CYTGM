//
//  ContentView.swift
//  CYTGM
//
//  Created by student on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            if UIDevice.current.orientation.isPortrait{
                let _ = changeOrientation()
            }
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
    func changeOrientation() {
            // tell the app to change the orientation
        let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
