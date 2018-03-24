import Foundation
import Common

// TODO: keep description here?

/// Base class for all project jobs
public class DevopsJob: Job { // TODO: find a better name
    let project: Project
    let shell: Shell
    
    public init(project: Project) {
        self.project = project
        self.shell = Shell()
    }
    
    public func run() {
        return
    }
}
