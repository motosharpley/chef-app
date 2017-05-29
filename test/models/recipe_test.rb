require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  
  def setup
    @user = User.create!(username: "testuser", email: "tester@email.com")
    @recipe = @user.recipes.build(name: "Test recipe name", description: "test recipe description")
  end
  
  test "recipe without user should be invalid" do
    @recipe.user_id = nil
    assert_not @recipe.valid?
  end
  
  test "recipe should be valid" do
    assert @recipe.valid?
  end
  
  test "name should be present" do
    @recipe.name = " "
    assert_not @recipe.valid?
  end
  
  test "description should be present" do
    @recipe.description = " "
    assert_not @recipe.valid?
  end
  
  test "description shouldn't be less than 5 charachters" do
    @recipe.description = "a" * 3
    assert_not @recipe.valid?
  end
  
  test "description shouldn't be more than 500 charachters" do
    @recipe.description = "a" * 501
    assert_not @recipe.valid?
  end
end
