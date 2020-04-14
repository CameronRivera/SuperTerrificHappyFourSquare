# SuperTerrificHappyFourSquare

This project allows a user to search for different venues of interest. The user can search for a specific type of venue in a specific location. Alternatively, if they omit a location for the search, the application will use their current location as the focal point. Once they have searched for a specific venue, the user can select an annotation on the map for more details about it. In addition, the venue can be saved to a collection of favourites for later viewing. 
This application uses the free FourSquare API as its backend. Because of the limitations placed on the free version, it is not ideal for practical use without upgrading to a premium account. When creating and designing the UI for this assignment, we drew inspiration from both FourSquare and Yelp.

Challenges 
One of the biggest challenges we all faced as a team was having to query an endpoint for information, and then using the newly retrieved information to query a different endpoint, while still being able to update the UI in a timely manner. Typically this results in certain information not being displayed on the screen because of the amount of asynchronous calls involved in this process. While this was a challenge that we all faced as a group, it was something that I encountered personally in a few other places. My usual fixes involved waiting for one query to end by using the sleep() method. However, I recently came upon a solution in the form of operation queues and dispatch groups.

swift 
let firstOperation = BlockOperation{
      let dispatchGroup = DispatchGroup()
       
      dispatchGroup.enter()
      FourSquareAPIClient.getVenuePhotos(venueID: model.id) { [weak self] (result) in
        switch result {
        case .failure(let error):
          print("error getting image: \(error)")
          dispatchGroup.leave()
        case .success(let photo):
          let prefix = photo.first?.prefix ?? ""
          let suffix = photo.first?.suffix ?? ""
          self?.imageURL = "\(prefix)original\(suffix)"
          dispatchGroup.leave()
        }
      }
       
      dispatchGroup.wait()
       
    }
     
    let secondOperation = BlockOperation{
       
      let dispatchGroup = DispatchGroup()
       
      dispatchGroup.enter()
      DispatchQueue.main.async{
        self.imageView?.getImage(with: self.imageURL) { [weak self] result in
          switch result{
          case .failure(let appError):
            print("this is the error we are looking for \(appError)")
            dispatchGroup.leave()
          case .success(let image):
            DispatchQueue.main.async{
              self?.venueImage.image = image
              dispatchGroup.leave()
            }
          }
        }
      }
      dispatchGroup.wait()
    }
     
    let thirdOperation = BlockOperation {
      DispatchQueue.main.async{
        self.venueName.text = model.name
      }
    }
     
    secondOperation.addDependency(firstOperation)
    thirdOperation.addDependency(secondOperation)
    operationQueue.addOperation(firstOperation)
    operationQueue.addOperation(secondOperation)
    operationQueue.addOperation(thirdOperation)
  }
  
  
  Jaheed Haynes (contributor)

The Main search controller (map controller)  presented many unexpected challenges. The most challenging portion was the text field searches. Initially when making the app I didn’t account that the two text fields had to be assigned specific search parameters. At first the text fields would populate the map with random things rather than the specific search of the user. I added a function that’s listed below that corrected this problem

swift

        
        if textField == searchView.locationSearch {
            getVenueWOCoordinate(query: searchView.venueSearchBar.text ?? "Pizza", location: searchView.locationSearch.text ?? "Brooklyn")
            resignFirstResponder()
        }
        
        if textField == searchView.venueSearchBar {
            getVenueWOCoordinate(query: searchView.venueSearchBar.text ?? "pizza", location: searchView.locationSearch.text ?? "Brooklyn" )
            resignFirstResponder()
        }
        
        //textFieldSelector(textField)
        convertPlaceNameToCoordinate(searchText)
        
        
        return true
    }




Collaborator: Chelsi Christmas 

As a new developer, the root of my challenges tend to stem from my understanding of different features of code development. My greatest challenge in this project was breaking down the components/parameters of each endpoint to create the APIClient and developing the projects unit tests. Our project utilized four endpoints. Through the use of Postman, a tool used to test API endpoints, I was able to decipher the correct placement of each parameter. Within the APIClient,  I provided each function with their respective parameters. I also created unit tests for each endpoint that determined the validity of the functions. Through these tasks, centered around our projects network services, I developed a better understanding of URL Session, Postman, and Unit Testing.

     
    
    swift
    
    static func getVenuesWithCoordinates(query: String, latitude: String, longitude: String, completion: @escaping (Result<[Venue], AppError>) -> ()) {
        let endpointURL = "https://api.foursquare.com/v2/venues/search?client_id=\(APIKey.clientID)&client_secret=\(APIKey.clientSecret)&v=20170210&ll=\(latitude),\(longitude)&query=\(query)"
        guard let url = URL(string: endpointURL) else {
            completion(.failure(.badURL(endpointURL)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (request) in
            switch request {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let search = try JSONDecoder().decode(VenueData.self, from: data)
                    completion(.success(search.response.venues))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }



Contributor: Yuliia Engman

I was excited to work as part of terrific team on such application. We replicated a Foursquare City Guide and at the same time every contributor added own personal touch to it either in form of customized UI elements or creative code. 
There were a lot of challenges in our project, but having very supportive and dedicative members our team was successfully completed the project before dead line.
Working on the part of the project that was assign to me, such as TabBarController, ShowAllCollectionsController, CategoryController and related Views, I was able to perform working code, but also learned a lot from my team members, who advised how to write code “cleaner”, that helped me to improve my technical skills.


Thank you, team, for nice work together. Sometimes, it was not easy due to challenges we faced, but it felt that all of us did their best to achieve our goal to create an app and we eventually did it!


swift

    extension ShowAllCollectionsController: CustomCollectionCellDelegate {
    
    func deleteCollectionButtonPressed(_ customCollectionCell: CustomCollectionCell) {
        guard let index = showAllCollectionView.collectionView.indexPath(for: customCollectionCell) else {
            return
        }
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete This Collection", style: .destructive) {
            UIAlertAction in
            self.deleteCollection(self.showAll, index.row)
            print("Deleted collection with name: \(self.nameOfNewCategory)")
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true)
    }
    
    private func deleteCollection(_ collectionCategory: [Collection], _ index: Int) {
        showAll[index].savedCollections.removeAll()
        showAll.remove(at: index)
    }
    }
