# frozen_string_literal: true

target :lib do
  signature 'sig'

  check 'lib'

  # Standard libraries
  library 'timeout'

  configure_code_diagnostics do |hash|
    hash[Steep::Diagnostic::Ruby::UnknownConstant] = :information
    hash[Steep::Diagnostic::Ruby::NoMethod] = :hint
    hash[Steep::Diagnostic::Ruby::ArgumentTypeMismatch] = :hint
    hash[Steep::Diagnostic::Ruby::UnexpectedPositionalArgument] = :hint
    hash[Steep::Diagnostic::Ruby::UnresolvedOverloading] = :hint
  end
end
