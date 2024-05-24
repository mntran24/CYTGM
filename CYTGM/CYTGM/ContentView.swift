//
//  ContentView.swift
//  CYTGM
//
//  Created by student on 5/10/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HStack {
            Image(systemName: "house")
                .resizable()
                .frame(width:45, height:45)
                .foregroundColor(.accentColor)
            Text("Home")
                .bold()
                .font(.title)
                .padding()
            Text("Watch")
                .bold()
                .font(.title)
                .padding()
        
        }
        Form{
            Section(header:Text("Recently Watched")){
                
            }
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
