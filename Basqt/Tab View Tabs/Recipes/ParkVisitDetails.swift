//
//  ParkVisitDetails.swift
//  NationalParks
//
//  Created by Osman Balci on 3/24/26.
//  Copyright © 2026 Osman Balci. All rights reserved.
//

import SwiftUI
import MapKit
import AVFoundation

fileprivate var parkVisitLocationCoordinate = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)

struct ParkVisitDetails: View {
    
    // Input Parameter
    let parkVisit: ParkVisit
    
    /*
     ----------------------------------------
     |   Publish-Subscribe Design Pattern   |
     ----------------------------------------
     Subscribe to state changes of the audioPlayer object instantiated from the
     @Observable class AudioPlayer. Whenever the audioPlayer object state changes
     refresh (update) this View, which means recompute the body var.
     */
    let audioPlayer: AudioPlayer
    
    //---------
    // Map View
    //---------
    var mapStyles = ["Standard", "Satellite", "Hybrid", "Globe"]
    @State private var selectedMapStyleIndex = 0
    
    var body: some View {
        
        parkVisitLocationCoordinate = CLLocationCoordinate2D(latitude: parkVisit.latitude, longitude: parkVisit.longitude)
        
        return AnyView(
            Form {
                Section(header: Text("National Park Name")) {
                    Text(parkVisit.parkName)
                }
                Section(header: Text("Date Visited National Park")) {
                    // ParkVisitDate() is given in ParkVisitDate.swift
                    ParkVisitDate(visitDate: parkVisit.date)
                }
                Section(header: Text("My Park Visit Rating")) {
                    Text(parkVisit.rating)
                }
                Section(header: Text("Park is in States")) {
                    Text(parkVisit.states)
                }
                Section(header: Text("Notes Taken by Speech to Text Conversion")) {
                    Text(parkVisit.speechToTextNotes)
                }
                Section(header: Text("Select Map Style"), footer: Text("Park Visit Location Map Provided by Apple Maps").italic()) {
                    
                    Picker("Select Map Style", selection: $selectedMapStyleIndex) {
                        ForEach(0 ..< mapStyles.count, id: \.self) { index in
                            Text(mapStyles[index])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    NavigationLink(destination: ParkVisitLocationOnMap(parkVisit: parkVisit, mapStyleIndex: selectedMapStyleIndex)) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .imageScale(.medium)
                                .font(Font.title.weight(.regular))
                            Text("Show Park Visit Location on Map")
                                .font(.system(size: 16))
                        }
                    }
                }
                if parkVisit.parkVisitPhotos!.count > 0 {
                    Section(header: Text("Park Visit Photos")) {
                        NavigationLink(destination: ParkVisitPhotosList(parkVisit: parkVisit)) {
                            HStack {
                                Image(systemName: "photo.stack")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Park Visit Photos")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
                if parkVisit.parkVisitAudios!.count > 0 {
                    Section(header: Text("Park Visit Voice Recordings")) {
                        NavigationLink(destination: ParkVisitAudiosList(parkVisit: parkVisit, audioPlayer: audioPlayer)) {
                            HStack {
                                Image(systemName: "waveform")
                                    .imageScale(.medium)
                                    .font(Font.title.weight(.regular))
                                Text("List Park Visit Voice Recordings")
                                    .font(.system(size: 16))
                            }
                        }
                    }
                }
            }   // End of Form
                .font(.system(size: 14))
                .navigationTitle("National Park Details")
                .toolbarTitleDisplayMode(.inline)
                .onDisappear() {
                    audioPlayer.stopAudioPlayer()
                }
            
        )   // End of AnyView
    }   // End of body var
    
    struct ParkVisitLocationOnMap: View {
        
        // Input Parameters
        let parkVisit: ParkVisit
        let mapStyleIndex: Int
        
        @State private var mapCameraPosition: MapCameraPosition = .region(
            MKCoordinateRegion(
                // parkVisitLocationCoordinate is a fileprivate var
                center: parkVisitLocationCoordinate,
                // 1 degree = 69 miles. 10 degrees = 690 miles
                span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
            )
        )
        
        var body: some View {
            
            var mapStyle: MapStyle = .standard
            
            switch mapStyleIndex {
            case 0:
                mapStyle = MapStyle.standard
            case 1:
                mapStyle = MapStyle.imagery     // Satellite
            case 2:
                mapStyle = MapStyle.hybrid
            case 3:
                mapStyle = MapStyle.hybrid(elevation: .realistic)   // Globe
            default:
                print("Map style is out of range!")
            }
            
            return AnyView(
                Map(position: $mapCameraPosition) {
                    Marker(parkVisit.parkName, coordinate: parkVisitLocationCoordinate)
                }
                .mapStyle(mapStyle)
                .navigationTitle(parkVisit.parkName)
                .toolbarTitleDisplayMode(.inline)
            )
        }   // End of body var
    }
    
}


