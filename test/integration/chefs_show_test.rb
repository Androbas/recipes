require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest

  def setup
    @chef = Chef.create!(chefname: "Androba", email: "amdres@mail.com", password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name:"panchos", description:"hervir salchicas, cortaqr pan por el medio, poner la salchicha entre los panes, agregar condimentos a gusto", chef: @chef)
    @recipe2 = @chef.recipes.build(name:"pollo", description: "cocinar pollo")
    @recipe2.save
  end

  test "should get chef show" do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipe), text: @recipe.name
    assert_select "a[href=?]", recipe_path(@recipe2), text: @recipe2.name
    assert_match @recipe.description, response.body
    assert_match @recipe2.description, response.body
    assert_match @chef.chefname, response.body
  end
end
