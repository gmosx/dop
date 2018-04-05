import Utility

// TODO: accept development/release options
// TODO: combine PushImageJob (with --push parameter)
// -> nah, separate deploy-image 'workflow'
// TODO: Automatically bump version if version == pushedversion (i.e. git tag)
// TODO: stop docker container on exit

class BuildImageCommand: DevopsCommand {
    var bumpOption: OptionArgument<Bool>!

    convenience init(project: Project) {
        self.init(name: "image-build", summary: "Build the container image", project: project)
    }

    override func setup() {
        bumpOption = argumentParser.add(option: "--bump", shortName: "-b", kind: Bool.self, usage: "Bump version before building image")
    }

    public func buildExecutable() throws {
        // TODO: try to avoid the hard-coded home paths. -v host-path:container-path

        let toolsContainerName = "swift-tools"

        try shell.execute(script:
            """
            docker rm -f \(toolsContainerName)
            docker run -it -d --name \(toolsContainerName) -v \(project.repoPath):\(project.repoPath) \(project.toolsImageName) /bin/bash
            docker exec -i \(toolsContainerName) sh -c "cd \(project.repoPath)/\(project.packagePath) && rm -rf .build && swift package clean"
            docker exec -i \(toolsContainerName) sh -c "cd \(project.repoPath)/\(project.packagePath) && swift package update"
            docker exec -i \(toolsContainerName) sh -c "cd \(project.repoPath)/\(project.packagePath) && swift build --configuration=release"
            """
        )
    }

    public func buildImage() throws {
        try shell.execute(script:
            """
            docker build -t \(project.fullImageName) .
            """
        )
    }

    override func run(result: ArgumentParser.Result) {
        do {
            if let _ = result.get(bumpOption) {
                BumpVersionCommand(project: project).run(result: result)
            }

            try buildExecutable()
            try buildImage()
        } catch {
            print(error.localizedDescription)
        }
    }
}
