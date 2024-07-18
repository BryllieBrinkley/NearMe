//
//  SelectedPlaceDetailView.swift
//  NearMe
//
//  Created by Jibryll Brinkley on 7/18/24.
//

import SwiftUI
import MapKit

struct SelectedPlaceDetailView: View {
    
    @Binding var mapItem: MKMapItem?
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                if let mapItem {
                    PlaceView(mapItem: mapItem)
                }
            }
            Image(systemName: "xmark.circle.fill")
                .padding([.trailing], 10)
                .onTapGesture {
                    mapItem = nil
                }
        }
    }
}

#Preview {
    
    let apple = Binding<MKMapItem?>(
        get: { PreviewData.apple },
        set: { _ in }
    )
    
    return SelectedPlaceDetailView(mapItem: apple)
}
