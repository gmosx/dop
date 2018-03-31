import Foundation

// TODO: Consider renaming to DopConfiguration
// TODO: Consider dop-config.json or project-descriptor.json
// TODO: Consider introducing nested levels

public struct ProjectDescriptor: Codable {
    public var name: String
    public var version: String
    public var description: String?
    public var maintainer: String?
    public var executableName: String?
    public var systemPackages: [String]?
    public var repoPath: String?
    public var packagePath: String? // TODO: consider swiftPackagePath
    public var userName: String?
    public var password: String?
    public var accountId: String?
    public var organizationName: String?
    public var spaceName: String?
    public var registry: String?
    public var registryNamespace: String?
    public var clusterName: String?
}
