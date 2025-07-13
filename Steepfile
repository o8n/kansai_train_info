# frozen_string_literal: true

target :lib do
  signature "sig"
  
  check "lib"
  
  # Standard libraries
  library "timeout"
  
  configure_code_diagnostics do |hash|
    hash[Steep::Diagnostic::Ruby::UnknownConstant] = :information
  end
end