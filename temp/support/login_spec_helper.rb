module LoginSpecHelper
  def login_as_an_active_user
    @current_user = FactoryGirl.create(:active_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_button "Sign In"
    fill_in "Email", :with => @current_user.email
    fill_in "Password", :with => ConfigCenter::Defaults::PASSWORD
    click_button "Sign In"
  end

  def login_as_an_admin_user
    @current_admin = FactoryGirl.create(:admin_user, email: "user@domain.com")
    visit sign_in_url
    expect(page).to have_button "Sign In"
    fill_in "Email", :with => @current_admin.email
    fill_in "Password", :with => ConfigCenter::Defaults::PASSWORD
    click_button "Sign In"
  end

  def expire_session
    time = Time.now - (ConfigCenter::Defaults::SESSION_TIME_OUT + 1.minute)
    @current_user.update_attributes(token_created_at: time)
  end
end