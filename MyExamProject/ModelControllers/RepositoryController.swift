import UIKit

class RepositoryController {
    
    func getList(view: ViewController, _ completionHandler: @escaping (_ response:[Repository]) -> Void) {
        var reposList : [Repository] = []
        let auth = "Shadow1702,0ebc055e7a829054e448ffe500639073105eef90"
        JsonAction.newGet(address: "https://api.github.com/users/Shadow1702/repos", requestHeaders: ["User-Agent" : "Awesome-Octocat-App", "authorization" : auth.toBase64()], view: view, {response in
            if let json = response?.value as? [Any] {
                for _rep in json {
                    if let rep = _rep as? [String : Any] {
                        let repository = Repository()
                        repository.name = rep["name"] as? String ?? "Error"
                        repository.url = rep["html_url"] as? String ?? "Error"
                        reposList.append(repository)
                    }
                }
            }
            completionHandler(reposList)
        })
    }

}
