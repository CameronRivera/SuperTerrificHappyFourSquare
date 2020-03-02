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
