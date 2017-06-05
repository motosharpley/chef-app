require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(username: "test chef", email: "test@email.com",  password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "test recipe", description: "test recipe description", user: @user)
    @recipe2 = @user.recipes.build(name: "another recipe", description: "antother recipe description")
    @recipe2.save
  end
  
  test "should get users show" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @user.username, response.body
  end
  
end
