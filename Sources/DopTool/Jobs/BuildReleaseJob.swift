import Foundation
import Common

/// Builds the production Linux image.
public final class BuildReleaseJob: Job {
    let projectDescriptor: ProjectDescriptor

    public init(projectDescriptor: ProjectDescriptor) {
        self.projectDescriptor = projectDescriptor
    }
    
    public func run() {
        let pd = projectDescriptor
        let shell = Shell()

        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path
        shell.execute(script: (
            """
            docker rm -f build-swift
            docker run -it -d --name build-swift -v \(pd.repoPath):\(pd.repoPath) reizu/ubuntu-build-swift /bin/bash
            docker exec -i build-swift sh -c "cd \(pd.repoPath)/\(pd.packagePath) && swift package clean && swift package update && swift build --configuration=release"
            """
        ))
    }
}
