require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
  @user = User.new(username: "testuser", email: "test@email.com", password: "password", password_confirmation: "password")
  end
  
  test "should be valid" do
    assert @user.valid?
  end
  
  test "name should be present" do
    @user.username = " "
    assert_not @user.valid?
  end
  
  test "should be less than 50 charachters" do
    @user.username = "a" * 51
    assert_not@user.valid?
  end
  
  test "email should be ppresent" do
    @user.email = " "
    assert_not @user.valid?
  end
  
  test "email should not be too long" do
    @user.email = "a" * 250 + "@email.com"
  end
  
  test "email should accept correct format" do
    valid_emails = %w[user@email.com tester@gmail.com m.first@yahoo.co j+smith@co.uk.org]
    valid_emails.each do |valids|
     @user.email = valids
     assert @user.valid?, "#{valids.inspect} should be valid"
    end
  end
  
  test "should reject invalid emails" do
    invalid_emails = %w[tester@exampl testme@email,com name.names@gmail. name@foo+bar.com]
    invalid_emails.each do |invalids|
      @user.email = invalids
      assert_not @user.valid?, "#{invalids.inspect} should be invalid"
    end
  end
  
  test "email should be unique and case insensitive " do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email should be lower case before hitting db" do
    mixed_email = "John@Example.com"
    @user.email = mixed_email
    @user.save
    assert_equal mixed_email.downcase, @user.reload.email
  end
  
  test "password should be present" do
    @user.password = @user.password_confirmation = " "
    assert_not @user.valid?
  end
  
  test "password should be at least 5 charachters" do
    @user.password = @user.password_confirmation = "x" * 4
    assert_not @user.valid?
  end
  
  test "associated recipes should be destroyed" do
    @user.save
    @user.recipes.create!(name: "test destroy", description: "test destroy function")
    assert_difference 'Recipe.count', -1 do
      @user.destroy
    end
  end
end