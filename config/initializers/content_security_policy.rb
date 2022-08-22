Rails.application.config.content_security_policy do |policy|
  policy.object_src   :none
  policy.script_src   :unsafe_inline, :unsafe_eval, :strict_dynamic, :https, :http
  policy.base_uri     :none

  # Specify URI for violation reports
  policy.report_uri '/csp-violation-report-endpoint'
end

# If you are using UJS then enable automatic nonce generation
Rails.application.config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }

# Set the nonce only to specific directives
Rails.application.config.content_security_policy_nonce_directives = %w[script-src]
