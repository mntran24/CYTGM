//
//  VideoView.swift
//  CYTGM
//
//  Created by student on 5/24/24.
//

import Foundation
import SwiftUI
struct VideoView: View {
    @State private var videos: [Video]
    var body: some View {
        Text("hi")
        
    }
    func parseJson() {

            if let url = Bundle.main.url(forResource: "Opps.json", withExtension: nil){

                if let data = try? Data(contentsOf: url){

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(dateFormatter)

                    do{
                        let videos = try decoder.decode([Video].self, from: data)
                        self.videos = videos

                    }
                    catch {
                        print("error trying parse json")
                    }
                }
            }
        }
}
//struct VideoView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoView()
//    }
//}

