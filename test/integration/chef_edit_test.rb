require 'test_helper'

class ChefEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Androba", email: "amdres@mail.com", password: "password", password_confirmation: "password")
  end

  test "Reject an invalid edit"  do
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: {chef: {chefname:"", email:"mail@mail.com"}}
    assert_template "chefs/edit"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end

  test "Accept valid edit" do
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: {chef: {chefname:"Androba", email:"mail@mail.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Androba", @chef.chefname
    assert_match "mail@mail.com", @chef.email
  end
end
