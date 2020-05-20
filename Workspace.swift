
import WorkspaceConfiguration

let configuration: WorkspaceConfiguration = {
  // The configuration is wrapped in a constant so that the file can be built as a library inside Xcode with autocomplete. The actual loader doesn’t need it wrapped like this.

  let configuration = WorkspaceConfiguration()

  // This maintains the standard “.gitignore” entries for a Swift package.
  configuration.git.manage = true

  return configuration
}()
