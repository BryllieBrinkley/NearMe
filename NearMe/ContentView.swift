//
//  ContentView.swift
//  NearMe
//
//  Created by Jibryll Brinkley on 7/17/24.
//

import SwiftUI
import MapKit


enum DisplayMode {
    case search
    case detail
}

struct ContentView: View {
    
    @State private var query: String = "Coffee"
    @State private var selectedDetent: PresentationDetent = .fraction(0.15)
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var isSearching: Bool = false
    @State private var mapItems: [MKMapItem] = []
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var selectedMapItem: MKMapItem?
    @State private var displayMode: DisplayMode = .search
    
    
    private func search() async {
    
        do {
           mapItems = try await performSearch(searchTerm: query, visibleRegion: visibleRegion)
            print(mapItems)
            isSearching = false
        } catch {
            mapItems = []
            print(error.localizedDescription)
            isSearching = false
        }
    }
    
    var body: some View {
        ZStack {
            Map(position: $position, selection: $selectedMapItem) {
                ForEach(mapItems, id: \.self) { mapItem in
                    Marker(item: mapItem)
                }
                UserAnnotation()
            }
            
            .onChange(of: locationManager.region,  {
                 position = .region(locationManager.region)
            })
            .sheet(isPresented: .constant(true), content: {
                VStack {
                    
                    switch displayMode {
                    case .search:
                        SearchBarView(search: $query, isSearching: $isSearching)
                        PlaceListView(mapItems: mapItems)
                    case .detail:
                        SelectedPlaceDetailView(mapItem: $selectedMapItem)
                            .padding()
                    }
                    
                    
                    
                    Spacer()
                }
                .presentationDetents([.fraction(0.15), .medium, .large])
                .presentationDragIndicator(.visible)
                .interactiveDismissDisabled()
                .presentationBackgroundInteraction(.enabled(upThrough: .medium))
            })
        }
        
        .onChange(of: selectedMapItem, {
            if selectedMapItem != nil {
                displayMode = .detail
            } else {
                displayMode = .search
            }
        })
        
        
        .onMapCameraChange { context in
            visibleRegion = context.region
        }
        .task(id: isSearching, {
            if isSearching {
                await search()
            }
        })
    }
}

#Preview {
    ContentView()
}
