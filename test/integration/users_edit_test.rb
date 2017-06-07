require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
  @user = User.create!(username: "testchef", email: "test@email.com", password: "password", password_confirmation: "password")
  @user2 = User.create!( username: "joe", email: "joe@email.com", password: "password", password_confirmation: "password" )
  @admin_user = User.create!( username: "admin", email: "admin@email.com", password: "password", password_confirmation: "password", admin: true )
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
  
  test "accept valid edit" do
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
  
  test "accept edit by admin user" do
    sign_in_as(@admin_user, "password")
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { username: "testchef2", email: "test2@email.com" } }
    assert_redirected_to @user
    assert_not flash.empty?
    @user.reload
    assert_match "testchef2", @user.username
    assert_match "test2@email.com", @user.email
  end
  
  test "redirect edit attempt by non-admin user" do
    sign_in_as(@user2, "password")
    updated_name = "jack"
    updated_email = "jack@email.com"
    patch user_path(@user), params: { user: { username: updated_name, email: updated_email } }
    assert_redirected_to users_path
    assert_not flash.empty?
    @user.reload
    assert_match "testchef", @user.username
    assert_match "test@email.com", @user.email
  end
end
