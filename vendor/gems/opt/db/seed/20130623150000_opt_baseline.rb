# USERS =====================================================================
Buildit::User.create(
 user_id:              '98A212F0204011E290E9040CCEDXXXXA',
 email_address:        'a',
 first_name:           'Aaron',
 last_name:            'Henderson',
 sso_plugin_code:      'BUILDIT',
 api_token:            'iLwEO1mJNp'
)
Buildit::User.create(
 user_id:              '98A212F0204011E290E9040CCEDXXOPT',
 email_address:        'opt',
 first_name:           'James',
 last_name:            'Fitzgerald',
 sso_plugin_code:      'BUILDIT',
 api_token:            'iLwEO1mJNp'
)
Buildit::User.all.each do |u|
  u.password = u.email_address
  u.save
end

# USER ROLES =====================================================================
Buildit::UserRole.create(
 user_role_id:         '98A212F0204011E290E9040CCED12345',
 user_id:              '98A212F0204011E290E9040CCEDXXXXA',
 role_id:              '323244F0204011EFCFE9040CCEDF842E', 
)
Buildit::UserRole.create(
 user_role_id:         '98A212F0204011E290E9040CCED67891',
 user_id:              '98A212F0204011E290E9040CCEDXXOPT',
 role_id:              '323244F0204011EFCFE9040CCEDF842E',
)
# APPLICATIONS =====================================================================
Buildit::Application.create(
  application_id:       'A25DC00EC19511E289BA20C9D04SALES',
  application_code:     'OPT',
  hub_xtype:            'opt-app-Hub',
  application_name:     'Optimum Performance Training',
  description:          'OPT Tracking System',
  is_enabled:           1
  )
# APPLICATION ROLES =====================================================================
Buildit::ApplicationRole.create(
  application_role_id:  '62BF1790C19511E289BA20C9DXX11111',
  application_id:       'A25DC00EC19511E289BA20C9D04SALES',
  role_id:              '323244F0204011EFCFE9040CCEDF842E',
  is_enabled:           1
  )