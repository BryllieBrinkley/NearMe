//
//  ActionButtons.swift
//  NearMe
//
//  Created by Jibryll Brinkley on 7/20/24.
//

import SwiftUI
import MapKit

struct ActionButtons: View {
    
    let mapItem: MKMapItem
    
    
    var body: some View {
        HStack {
            
            Button(action: {
                if let phone = mapItem.phoneNumber {
                    let numericPhoneNumber = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                        makeCall(phone: numericPhoneNumber)
                    
                }
            }, label: {
                HStack {
                    Image(systemName: "phone.fill")
                    Text("Call")
                }
            }).buttonStyle(.bordered)
            
            
            Button(action: {
                MKMapItem.openMaps(with: [mapItem])
            }, label: {
                HStack {
                    Image(systemName: "car.circle.fill")
                    Text("Take Me There")
                }
            }).buttonStyle(.bordered)
                .tint(.green)
            Spacer()
        }
    }
}

#Preview {
    ActionButtons(mapItem: PreviewData.apple)
}
