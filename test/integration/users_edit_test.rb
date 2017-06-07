require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
  @user = User.create!(username: "testchef", email: "test@email.com", password: "password", password_confirmation: "password")
  end
  
  test "reject invalid edit" do
    sign_in_as(@user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { username: " ", email: "test@email.com" } }
    assert_template 'users/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "accept valid update" do
    sign_in_as(@user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { username: "testchef1", email: "test1@email.com" } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_match "testchef1", @user.username
    assert_match "test1@email.com", @user.email
  end
end
