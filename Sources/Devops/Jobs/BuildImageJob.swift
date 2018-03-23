import Foundation

// TODO: combine BumpVersionJob (with --bump)
// TODO: combine PushImageJob (with --push parameter)
// -> nah, separate deploy-image 'workflow'

/// Build the release image
public final class BuildImageJob: BaseToolJob {
    public func buildExecutable() {
        let shell = Shell()

        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path
        shell.execute(script: (
            """
            docker rm -f build-swift
            docker run -it -d --name build-swift -v \(project.repoPath):\(project.repoPath) reizu/ubuntu-build-swift /bin/bash
            docker exec -i build-swift sh -c "cd \(project.repoPath)/\(project.packagePath) && rm -rf .build && swift package clean && swift package update && swift build --configuration=release"
            """
        ))
    }

    public func buildImage() {
        let shell = Shell()

        shell.execute(script: (
            """
            docker build -t \(project.fullImageName) .
            """
        ))
    }

    public override func run() {
        buildExecutable()
        buildImage()
    }
}
