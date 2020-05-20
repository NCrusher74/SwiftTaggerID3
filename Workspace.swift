
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

  // #workaround(Not sure which of these style guidelines the project wants to follow. These ones are disabled because they currently flag violations.)
  // These are rules provided by Workspace natively.
  configuration.proofreading.rules.subtract([
    .calloutCasing,
    .parameterGrouping,
    .syntaxColoring,
    .manualWarnings,
    .marks,
    .unicode
  ])
  // These are rules provided by swift‐format, Swift’s official code formatter.
  for ruleName in [
    "BeginDocumentationCommentWithOneLineSummary",
    "DoNotUseSemicolons",
    "GroupNumericLiterals",
    "NoAccessLevelOnExtensionDeclaration",
    "UseSingleLinePropertyGetter",
    "UseTripleSlashForDocumentationComments"
    ] {
      configuration.proofreading.swiftFormatConfiguration?.rules[ruleName] = false
  }
  // #workaround(swift‐format currently flags indentation violations that cannot be suppressed without disabling swift‐format altogether.)
  configuration.proofreading.swiftFormatConfiguration = nil

  // #workaround(Not everything is being tested yet.)
  configuration.testing.enforceCoverage = false

  // #workaround(Not everything is documented yet.)
  configuration.documentation.api.enforceCoverage = false

  return configuration
}()
