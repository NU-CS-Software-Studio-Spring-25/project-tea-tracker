class Users::RegistrationsController < Devise::RegistrationsController
  # ... existing code ...

  protected

  def after_sign_up_path_for(resource)
    initial_upload_teas_path
  end

  # ... rest of existing code ...
end 