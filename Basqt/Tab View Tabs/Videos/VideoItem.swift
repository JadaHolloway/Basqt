//
//  VideoItem.swift
//  Blacksburg
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 1/20/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct VideoItem: View {
    
    // Input Parameter
    let video: Video
    
    var body: some View {
        HStack {
            // Default file "ImageUnavailable" must be present in Assets.xcassets
            // getImageFromUrl is given in UtilityFunctions.swift to display video's thumbnail image
            getImageFromUrl(url: "https://img.youtube.com/vi/\(video.youTubeId)/mqdefault.jpg", defaultFilename: "ImageUnavailable")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120)
            
            VStack(alignment: .leading) {
                Text(video.title)
                Text(video.releaseDate)
                Text(video.duration)
            }
            // Set font and size for the whole VStack content
            .font(.system(size: 14))
        }
    }
}
