require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = User.create!(username: "test chef", email: "test@email.com",  password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name: "test recipe", description: "test recipe description", user: @user)
  end
  
  test "reject invalid update recipe" do
    sign_in_as(@user, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: { recipe: {name: " ", description:"test description"}}
    assert_template 'recipes/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test "successfully edit recipe" do
    sign_in_as(@user, "password")
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "updated recipe name"
    updated_description = "updated description"
    patch recipe_path(@recipe), params: { recipe: { name: updated_name, description: updated_description } }
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
end
