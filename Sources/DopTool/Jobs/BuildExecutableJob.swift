import Foundation

// TODO: consider renaming build-executable (accept development/release options)

/// Builds the production Linux image.
public final class BuildExecutableJob: BaseToolJob {
    public override func run() {
        let shell = Shell()

        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path
        shell.execute(script: (
            """
            docker rm -f build-swift
            docker run -it -d --name build-swift -v \(project.repoPath):\(project.repoPath) reizu/ubuntu-build-swift /bin/bash
            docker exec -i build-swift sh -c "cd \(project.repoPath)/\(project.packagePath) && swift package clean && swift package update && swift build --configuration=release"
            """
        ))
    }
}
