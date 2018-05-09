import Foundation
import struct Foundation.URL
import Utility

// TODO: Interactively ask for the value if missing!
fileprivate func env(_ name: String) -> String {
    if let value = ProcessInfo.processInfo.environment[name] {
        return value
    } else {
        // TODO: print to stderr
        print("Environment variable `\(name)` is not defined")
        exit(-1)
    }
}

public class Project {
    private(set) var descriptor: ProjectDescriptor

    public init(descriptor: ProjectDescriptor) {
        self.descriptor = descriptor
    }

    public convenience init(from url: URL = URL(fileURLWithPath: "dop.json")) throws {
        let descriptorData = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let descriptor = try jsonDecoder.decode(ProjectDescriptor.self, from: descriptorData)

        self.init(descriptor: descriptor)
    }

    public var name: String {
        return descriptor.name
    }

    public var version: String {
        return descriptor.version
    }

    public var description: String {
        return descriptor.description ?? "\(name) \(version)"
    }

    public var maintainer: String? {
        return descriptor.maintainer
    }

    public var swiftVersion: String {
        return descriptor.swiftVersion ?? "4.1"
    }

    public var executableName: String {
        return descriptor.executableName ?? name
    }

    public var systemPackages: [String] {
        return descriptor.systemPackages ?? []
    }

    public var repoPath: String {
        return descriptor.repoPath ?? env("DOP_REPO_PATH")
    }

    public var packagePath: String {
        return descriptor.packagePath ?? env("DOP_PACKAGE_PATH")
    }

    public var userName: String {
        return descriptor.userName ?? env("DOP_USER_NAME")
    }

    public var password: String {
        return descriptor.password ?? env("DOP_PASSWORD")
    }

    public var accountId: String {
        return descriptor.accountId ?? env("DOP_ACCOUNT_ID")
    }

    public var organizationName: String {
        return descriptor.organizationName ?? env("DOP_ORGANIZATION_NAME")
    }

    public var spaceName: String {
        return descriptor.spaceName ?? env("DOP_SPACE_NAME")
    }

    public var registry: String {
        return descriptor.registry ?? env("DOP_REGISTRY")
    }

    public var registryNamespace: String {
        return descriptor.registryNamespace ?? env("DOP_REGISTRY_NAMESPACE")
    }

    public var clusterName: String {
        return descriptor.clusterName ?? env("DOP_CLUSTER_NAME")
    }

    public var imageName: String {
        return "\(registryNamespace)/\(name)"
    }

    public var fullImageName: String {
        return "\(registry)/\(registryNamespace)/\(name):\(version)"
    }

    public var toolsImageName: String {
        return "reizu/\(name)-tools"
    }

    public var chartPath: String {
        return "chart/\(name)"
    }

    public var helmPackagePath: String {
        return "\(name)-\(version).tgz"
    }

    public var license: String {
        return descriptor.license ?? "PROPRIETARY"
    }

    @discardableResult
    public func bumpVersion() -> String {
        let currentVersion = Version(stringLiteral: version)
        let nextVersion = Version(currentVersion.major, currentVersion.minor + 1, 0)
        descriptor.version = "\(nextVersion)"
        return version
    }
}
