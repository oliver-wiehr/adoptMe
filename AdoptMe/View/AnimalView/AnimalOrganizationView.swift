//
//  AnimalOrganizationView.swift
//  AdoptMe
//
//  Created by Oliver Wiehr on 10/22/22.
//

import SwiftUI

struct AnimalOrganizationView: View {
    @EnvironmentObject var adoptMe: AdoptMe
    var organization: Organization
    
    var body: some View {
        VStack {
            HStack {
                
                if let photo = organization.photos.first, let imageURL = URL(string: photo.largeSize!) {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 50.0, height: 50.0)
                    .cornerRadius(/*@START_MENU_TOKEN@*/5.0/*@END_MENU_TOKEN@*/)
                }
                VStack {
                    Text(organization.name)
                    Text(organization.address?.city ?? "")
                }
            }
            HStack {
                if let phone = organization.phone {
                    Button {
                        adoptMe.callPhone(phone)
                    } label: {
                        Image(systemName: "phone.fill")
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
                if let email = organization.email {
                    Button {
                        adoptMe.writeEmail(email)
                    } label: {
                        Image(systemName: "envelope.fill")
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
            }
            .frame(maxWidth: 100)
            .padding()
            
            if let location = organization.address?.coordinate {
                OrganizationMap(
                    organization: organization,
                    location: location,
                    region: MKCoordinateRegion(center: location, latitudinalMeters: 7500, longitudinalMeters: 7500)
                )
            }
        }
    }
}
