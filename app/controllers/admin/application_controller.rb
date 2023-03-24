class Admin::ApplicationController <ApplicationController
  before_action def check_is_admin
    # Check that only admin users have access to the admin area.
    authorize! :manage, @Admin
  end

end