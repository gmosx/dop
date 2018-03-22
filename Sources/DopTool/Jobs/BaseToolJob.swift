import Foundation
import Common

// TODO: keep description here?

/// Base class for all project jobs
public class BaseToolJob: Job { // TODO: find a better name
    let project: Project
    
    public init(project: Project) {
        self.project = project
    }
    
    public func run() {
        return
    }
}
