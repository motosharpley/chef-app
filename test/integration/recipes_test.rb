require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create!(username: "test chef", email: "test@email.com")
    @recipe = Recipe.create(name: "test recipe", description: "test recipe description", user: @user)
    @recipe2 = @user.recipes.build(name: "another recipe", description: "antother recipe description")
    @recipe2.save
  end
  
  test "should get recipes index" do
   get recipes_url
   assert_response :success
  end
  
  test "should get recipes listing" do
    get recipes_path
    assert_template 'recipes/index'
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body
  end
end
