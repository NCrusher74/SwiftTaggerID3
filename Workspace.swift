
import WorkspaceConfiguration

let configuration: WorkspaceConfiguration = {
  // The configuration is wrapped in a constant so that the file can be built as a library inside Xcode with autocomplete. The actual configuration loader doesn’t need it wrapped like this.

  let configuration = WorkspaceConfiguration()

  // To my knowledge, SwiftTaggerID3 only supports macOS so far. This removes the others.
  configuration.supportedPlatforms.subtract([
    .windows,
    .web,
    .linux,
    .tvOS,
    .iOS,
    .android,
    .watchOS
  ])

  // This maintains standard “.gitignore” entries for a Swift package.
  configuration.git.manage = true

  return configuration
}()
