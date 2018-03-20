import Foundation

public struct ProjectDescriptor: Codable {
    public let name: String
    public let version: String
    public let description: String
    public let executableName: String
    public let clusterName: String
    public let maintainer: String?
    public let packagePath: String
    public let repoPath: String?
    // registryBaseURL
    // apt-get libraries
}

public func loadProjectDescriptor() -> ProjectDescriptor? {
    do {
        let fileURL = URL(fileURLWithPath: "dop.json")
        let descriptorData = try Data(contentsOf: fileURL)

        let jsonDecoder = JSONDecoder()
        let descriptor = try jsonDecoder.decode(ProjectDescriptor.self, from: descriptorData)

        return descriptor
    } catch {
        print(error.localizedDescription)
        return nil
    }
}
