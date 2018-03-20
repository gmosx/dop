import Foundation
import Common

/// Builds the production Linux image.
public final class BuildReleaseJob: Job {
    let projectDescriptor: ProjectDescriptor

    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }
    
    func dockerExec(_ command: String) -> String {
        return "docker exec -i build-swift \"\(command)\""
    }

    public func run() {
        let pd = projectDescriptor
        let shell = Shell()

        guard let repoPath = pd.repoPath ?? ProcessInfo.processInfo.environment["DOP_REPO_PATH"] else {
            print("The repo path is not defined. Try to set the `DOP_REPO_PATH` environment variable")
            return
        }

        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path
        shell.execute(script: (
            """
            docker rm -f build-swift
            docker run -it -d --name build-swift -v \(repoPath):\(repoPath) reizu/ubuntu-build-swift /bin/bash
            docker exec -i build-swift sh -c "cd \(repoPath)/\(pd.packagePath) && swift package clean && swift package update && swift build --configuration=release"
            """
        ))
    }
}
