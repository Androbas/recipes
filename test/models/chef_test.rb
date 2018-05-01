require 'test_helper'

class ChefTest < ActiveSupport::TestCase
  def setup
    @chef = Chef.new(chefname: "Androba", email: "mail@mail.com", password: "password", password_confirmation: "password")

  end

  test "should be valid" do
    assert @chef.valid?
  end

  test "name should be present" do
    @chef.chefname = ""
    assert_not @chef.valid?
  end

  test "name should be less than 30 characters" do
    @chef.chefname = "a" *31
    assert_not @chef.valid?
  end

  test "email should be present" do
    @chef.email = ""
    assert_not @chef.valid?
  end

  test "email should be less than 250 characters" do
    @chef.email = "a" *250 + "@gmail.com"
    assert_not @chef.valid?
  end

  test "email should be valid format" do
    valid_emails = %w[user@example.com andres@gmail.com.ar a.first@hotmail.ca jhon+smith@co.uk.org]
    valid_emails.each do |valids|
      @chef.email = valids
      assert @chef.valid?, "#{[valids.inspect]} should be valid"
    end
  end

  test "EMAIL SHOULD REJECT INVALID EMAILS" do
    invalid_emails = %w[mail@mailcom mail@example,com arooba@mail. nombreenmail.com.ar]
    invalid_emails.each do |invalid|
      @chef.email = invalid
      assert_not @chef.valid?, "#{invalid.inspect} should be invalid"
    end
  end

  test "email should be unique and case insensitive" do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test "email should be lower case before saving in db" do
    mixed_email = "AndreAria@mail.com"
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end

  test "password should be present" do
    @chef.password = @chef.password_confirmation = ""
    assert_not @chef.valid?
  end

  test "password min characters 5" do
    @chef.password = @chef.password_confirmation = "x" * 4
    assert_not @chef.valid?
  end

end
