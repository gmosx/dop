import Foundation

/// Push the release image to the registry
public final class PushImageJob: BaseToolJob {
    public override func run() {
        let shell = Shell()

        shell.execute(script: (
            """
            docker push \(project.fullImageName)
            """
        ))
    }
}
