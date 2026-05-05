//
//  VideoDetails.swift
//  Blacksburg
//
//  Created by Osman Balci on 1/20/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI

struct VideoDetails: View {
    
    // Input Parameter
    let video: Video
    
    var body: some View {
        Form {
            Section(header: Text("Video Title")) {
                Text(video.title)
            }
            Section(header: Text("Video Thumbnail Image"), footer: Text(video.youTubeId)) {
                /*
                You can obtain YouTube thumbnail image with the quality and size you desire:
                    Default:               default.jpg          120x90    <-- 4:3 ratio
                    Medium Quality:        mqdefault.jpg        320x180   <-- 16:9 ratio (Recommended)
                    High Quality:          hqdefault.jpg        480x360   <-- 4:3 ratio
                    Standard Definition:   sddefault.jpg        640x480   <-- 4:3 ratio
                    Maximum Resolution:    maxresdefault.jpg    1280x720  <-- 16:9 ratio (too large file size)
                 */

                // Default file "ImageUnavailable" must be present in Assets.xcassets
                // getImageFromUrl is given in UtilityFunctions.swift to display video's thumbnail image
                getImageFromUrl(url: "https://img.youtube.com/vi/\(video.youTubeId)/mqdefault.jpg", defaultFilename: "ImageUnavailable")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 320)
            }
            Section(header: Text("Play Video")) {
                NavigationLink(destination:
                    WebView(url: "https://www.youtube.com/watch?v=\(video.youTubeId)")
                        .edgesIgnoringSafeArea(.all)
                   /*
                    ---------------------------------------------------------------------------------------
                    Some YouTube videos do not allow playing as "embed"ed within WebView in an app.
                    In that case, the video can be played on YouTube website by using the "watch" parameter.
                    WebView(url: "https://www.youtube.com/watch?v=\(video.youTubeId)")
                    ---------------------------------------------------------------------------------------
                    */
                ){
                    HStack {
                        Image(systemName: "play.rectangle.fill")
                            .imageScale(.medium)
                            .font(Font.title.weight(.regular))
                            .foregroundColor(.red)
                        Text("Play YouTube Video")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                }
            }
            Section(header: Text("Video Release Date")) {
                videoReleaseDate
            }
            Section(header: Text("Video Duration Time"), footer: Text("hours:mins:secs")) {
                Text(video.duration)
            }
            
        }   // End of Form
        .font(.system(size: 14))
        .navigationTitle("YouTube Video")
        .toolbarTitleDisplayMode(.inline)
        
    }   // End of body var
    
    var videoReleaseDate: Text {
         
        // Create an instance of DateFormatter
        let dateFormatter = DateFormatter()
         
        // Set the date format to yyyy-MM-dd
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
         
        // Convert date String from "yyyy-MM-dd" to Date struct
        let dateStruct = dateFormatter.date(from: video.releaseDate)
         
        // Create a new instance of DateFormatter
        let newDateFormatter = DateFormatter()
         
        newDateFormatter.locale = Locale(identifier: "en_US")
        newDateFormatter.dateStyle = .full      // Thursday, November 7, 2019
        newDateFormatter.timeStyle = .none
         
        // Obtain newly formatted Date String as "Thursday, November 7, 2019"
        let dateWithNewFormat = newDateFormatter.string(from: dateStruct!)
        
        return Text(dateWithNewFormat)
    }
}
