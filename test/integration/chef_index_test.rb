require 'test_helper'

class ChefIndexTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Androba", email:"mail@mail.com", password:"password", password_confirmation:"password")
    @chef2 = Chef.create!(chefname: "Droba", email:"droba@mail.com", password:"password", password_confirmation:"password")
    @admin_user = Chef.create!(chefname: "Droba2", email:"droba2@mail.com", password:"password", password_confirmation:"password", admin: true)
  end

  test "should get chefs index" do
    get chefs_url
    assert_template 'chefs/index'
    assert_select "a[href=?]", chef_path(@chef),text: @chef.chefname.capitalize
    assert_select "a[href=?]", chef_path(@chef2),text: @chef2.chefname.capitalize
  end

  test "should delete chef" do
    sign_in_as(@admin_user, 'password')
    get chefs_path
    assert_template 'chefs/index'
    assert_difference "Chef.count", -1 do
      delete chef_path(@chef2)
    end
    assert_redirected_to chefs_path
    assert_not flash.empty?
  end
end
