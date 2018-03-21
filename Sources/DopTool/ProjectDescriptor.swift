import Foundation

// TODO: Just keep the container and use getters?
// TODO: Consider renaming to DopConfiguration
// TODO: Consider dop-config.json or project-descriptor.json
// TODO: Consider introducing nested levels
// TODO: apt-get libraries

public struct ProjectDescriptor: Codable {
    public let name: String
    public let version: String
    public let description: String?
    public let maintainer: String?
    public let executableName: String
    public let repoPath: String
    public let packagePath: String
    public let userName: String
    public let password: String
    public let accountId: String
    public let organizationName: String
    public let spaceName: String
    public let registry: String
    public let registryNamespace: String
    public let clusterName: String

    // https://stackoverflow.com/questions/44575293/with-jsondecoder-in-swift-4-can-missing-keys-use-a-default-value-instead-of-hav
    public init(from decoder: Decoder) throws {
        let env = ProcessInfo.processInfo.environment
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else {
            throw DecodingError.dataCorruptedError(forKey: .name, in: container, debugDescription: "Key `name` not defined")
        }

        if let version = try container.decodeIfPresent(String.self, forKey: .version) {
            self.version = version
        } else {
            throw DecodingError.dataCorruptedError(forKey: .version, in: container, debugDescription: "Key `version` not defined")
        }

        self.description = try container.decodeIfPresent(String.self, forKey: .description)

        self.maintainer = try container.decodeIfPresent(String.self, forKey: .maintainer)

        if let executableName = try container.decodeIfPresent(String.self, forKey: .executableName) {
            self.executableName = executableName
        } else {
            throw DecodingError.dataCorruptedError(forKey: .executableName, in: container, debugDescription: "Key `executableName` not defined")
        }

        if let repoPath = try container.decodeIfPresent(String.self, forKey: .repoPath) ?? env["DOP_REPO_PATH"] {
            self.repoPath = repoPath
        } else {
            throw DecodingError.dataCorruptedError(forKey: .repoPath, in: container, debugDescription: "Key `repoPath` not defined")
        }

        if let packagePath = try container.decodeIfPresent(String.self, forKey: .packagePath) ?? env["DOP_REPO_PATH"] {
            self.packagePath = packagePath
        } else {
            throw DecodingError.dataCorruptedError(forKey: .packagePath, in: container, debugDescription: "Key `packagePath` not defined")
        }

        if let userName = try container.decodeIfPresent(String.self, forKey: .userName) ?? env["DOP_USER_NAME"] {
            self.userName = userName
        } else {
            throw DecodingError.dataCorruptedError(forKey: .userName, in: container, debugDescription: "Key `userName` not defined")
        }

        if let password = try container.decodeIfPresent(String.self, forKey: .password) ?? env["DOP_PASSWORD"] {
            self.password = password
        } else {
            throw DecodingError.dataCorruptedError(forKey: .password, in: container, debugDescription: "Key `password` not defined")
        }

        if let accountId = try container.decodeIfPresent(String.self, forKey: .accountId) ?? env["DOP_ACCOUNT_ID"] {
            self.accountId = accountId
        } else {
            throw DecodingError.dataCorruptedError(forKey: .accountId, in: container, debugDescription: "Key `accountId` not defined")
        }

        if let organizationName = try container.decodeIfPresent(String.self, forKey: .organizationName) ?? env["DOP_ORGANIZATION_NAME"] {
            self.organizationName = organizationName
        } else {
            throw DecodingError.dataCorruptedError(forKey: .organizationName, in: container, debugDescription: "Key `organizationName` not defined")
        }

        if let spaceName = try container.decodeIfPresent(String.self, forKey: .spaceName) ?? env["DOP_SPACE_NAME"] {
            self.spaceName = spaceName
        } else {
            throw DecodingError.dataCorruptedError(forKey: .spaceName, in: container, debugDescription: "Key `spaceName` not defined")
        }

        self.registry = try container.decodeIfPresent(String.self, forKey: .registry) ?? env["DOP_REGISTRY"] ?? "registry.ng.bluemix.net"

        self.registryNamespace = try container.decodeIfPresent(String.self, forKey: .registryNamespace) ?? env["DOP_REGISTRY_NAMESPACE"] ?? "reizu"

        if let clusterName = try container.decodeIfPresent(String.self, forKey: .clusterName) ?? env["DOP_CLUSTER_NAME"] {
            self.clusterName = clusterName
        } else {
            throw DecodingError.dataCorruptedError(forKey: .clusterName, in: container, debugDescription: "Key `clusterName` not defined")
        }
    }

    public var imageName: String {
        return "\(registryNamespace)/(name)"
    }
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
