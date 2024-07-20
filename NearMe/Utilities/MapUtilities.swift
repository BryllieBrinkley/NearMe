//
//  MapUtilities.swift
//  NearMe
//
//  Created by Jibryll Brinkley on 7/18/24.
//

import Foundation
import MapKit


func calculateDirections(to: MKMapItem, from: MKMapItem) async -> MKRoute? {
    
    let directionsRequest = MKDirections.Request()
    directionsRequest.transportType = .automobile
    directionsRequest.source = from
    directionsRequest.destination = to
    
    let directions = MKDirections(request: directionsRequest)
    
    let response = try? await directions.calculate()
    return response?.routes.first
}



func calculateDistance(to: CLLocation, from: CLLocation) -> Measurement<UnitLength> {
    
    let distanceInMeters = from.distance(from: to)
    return Measurement(value: distanceInMeters, unit: .meters)
    
}

func performSearch(searchTerm: String, visibleRegion: MKCoordinateRegion?) async throws -> [MKMapItem] {
    
    let request = MKLocalSearch.Request()
    request.naturalLanguageQuery = searchTerm
    request.resultTypes = .pointOfInterest
    
    guard let region = visibleRegion else { return [] }
    request.region = region
    
    let search = MKLocalSearch(request: request)
    let response = try await search.start()
    
    return response.mapItems
}
