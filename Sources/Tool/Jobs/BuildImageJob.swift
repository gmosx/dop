import Foundation

// TODO: combine BumpVersionJob (with --bump)
// TODO: combine PushImageJob (with --push parameter)

/// Build the release image
public final class BuildImageJob: BaseToolJob {
    public override func run() {
        let shell = Shell()
        
        shell.execute(script: (
            """
            git tag \(project.version)
            docker build -t \(project.fullImageName) .
            """
        ))
    }
}
