require 'test_helper'

class ChefEditTest < ActionDispatch::IntegrationTest
  def setup
    @chef = Chef.create!(chefname: "Androba", email: "andres@mail.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "Droba", email:"droba@mail.com", password:"password", password_confirmation:"password")
    @admin_user = Chef.create!(chefname: "Droba2", email:"droba2@mail.com", password:"password", password_confirmation:"password", admin: true)
  end

  test "Reject an invalid edit"  do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: {chef: {chefname:"", email:"mail@mail.com"}}
    assert_template "chefs/edit"
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end

  test "Accept valid edit" do
    sign_in_as(@chef, 'password')
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: {chef: {chefname:"Androba", email:"mail@mail.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Androba", @chef.chefname
    assert_match "mail@mail.com", @chef.email
  end

  test "accept edit attempt by admin user" do
    sign_in_as(@admin_user, 'password')
    get edit_chef_path(@chef)
    assert_template "chefs/edit"
    patch chef_path(@chef), params: {chef: {chefname:"Androba3", email:"mail3@mail.com"}}
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "Androba3", @chef.chefname
    assert_match "mail3@mail.com", @chef.email
  end

  test "redirect edit attempt by another non-admin user" do
    sign_in_as(@chef2, 'password')
    updated_name = "bob"
    updated_email ="mailto@mailito.com"
    patch chef_path(@chef), params: {chef: {chefname: updated_name, email: updated_email}}
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "Androba", @chef.chefname
    assert_match "andres@mail.com", @chef.email
  end
end
