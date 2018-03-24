import Foundation

// TODO: accept development/release options
// TODO: combine BumpVersionJob (with --bump)
// TODO: combine PushImageJob (with --push parameter)
// -> nah, separate deploy-image 'workflow'

/// Build the release image
public final class BuildImageJob: DevopsJob {
    public func buildExecutable() {
        let shell = Shell()

        // TODO: Keep the Dockerfile-tools image in the directory, like idt
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path

        do {
            try shell.execute(script:
                """
                docker rm -f build-swift
                docker run -it -d --name build-swift -v \(project.repoPath):\(project.repoPath) reizu/ubuntu-build-swift /bin/bash
                docker exec -i build-swift sh -c "cd \(project.repoPath)/\(project.packagePath) && rm -rf .build && swift package clean"
                docker exec -i build-swift sh -c "cd \(project.repoPath)/\(project.packagePath) && swift package update"
                docker exec -i build-swift sh -c "cd \(project.repoPath)/\(project.packagePath) && swift build --configuration=release"
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }

    public func buildImage() {
        let shell = Shell()

        do {
            try shell.execute(script:
                """
                docker build -t \(project.fullImageName) .
                """
            )
        } catch {
            print(error.localizedDescription)
        }
    }

    public override func run() {
        buildExecutable()
        buildImage()
    }
}
