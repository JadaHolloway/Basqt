//
//  VideosList.swift
//  Blacksburg
//
//  Created by Osman Balci, Micki Ross, Jada Holloway, and Jonathan Hernandez Velasquez on 1/20/26.
//  Copyright © 2026 Osman Balci, Micki Ross, Jada Holloway, Jonathan Hernandez Velasquez. All rights reserved.
//

import SwiftUI

struct VideosList: View {
    
    var body: some View {
        NavigationStack {
            List {
                // Since Video struct does not have the 'id' property, use 'youTubeId' as the 'id'
                ForEach(videoStructList, id: \.youTubeId) { aVideo in
                    NavigationLink(destination: VideoDetails(video: aVideo)) {
                        VideoItem(video: aVideo)
                    }
                }
                .navigationTitle("10 Minute Recipe Videos")
                .toolbarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    VideosList()
}
