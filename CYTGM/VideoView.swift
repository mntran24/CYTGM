//
//  VideoView.swift
//  CYTGM
//
//  Created by student on 5/24/24.
//

import Foundation
import SwiftUI
struct VideoView: View {
    var body: some View {
        Text("hey")
        let jsonData = """
    {
        "resolution": "full-hd",
                "elements": [
                    {
                        "type": "video",
                        "src": "https://assets.json2video.com/assets/videos/beach-01.mp4"
                    }
            }
        ]
    }
    """.data(using: .utf8)! // Convert string to Data
        
        let decoder = JSONDecoder()
    }
    }
struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView()
    }
}

