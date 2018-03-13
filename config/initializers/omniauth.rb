OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, 172979426378979, "83df536594c689da72eb4075910e1772", {:client_options => {:ssl => {:ca_file => '/etc/pki/tls/certs/ca-bundle.crt'}}}
  provider :google_oauth2, '849829348817-nppckbfmc5lbnc9o65p47jbp1565crk1.apps.googleusercontent.com', 'W-69SbFHXRanLFeruphhB2Zu', skip_jwt: true
  provider :github, '7e16523ac8ccdabbd5cf', 'ba28e526023f03a28036aac7f9cbcda574f38e8b', scope: "user:email,user:follow"
end