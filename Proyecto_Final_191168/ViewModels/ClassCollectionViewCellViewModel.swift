import Foundation

struct ClassCollectionViewCellViewModel {
  public let nombreClase: String
public let textoClase: String
  private let imagenUrlclase: URL?


  init(
    nombreClase: String,
    textoClase:String,
    imagenUrlclase: URL?
  ){
    self.nombreClase = nombreClase
      self.textoClase = textoClase
    self.imagenUrlclase = imagenUrlclase
  }

  public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void){
    guard let url = imagenUrlclase else {
      completion(.failure(URLError(.badURL)))
      return 
    }
    let request = URLRequest(url: url)
    let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                                                          guard let data = data, error ++ nil else {
                                                            completion(.failure(error ?? URLError(.badServerResponse)))
                                                            return
                                                          }
                                                          completion(.success(data))
  }
    task.resume()
}
