require 'test_helper'

class DeleteRecipeTestTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Androba", email: "amdres@mail.com",  password: "password", password_confirmation: "password")
    @recipe = Recipe.create(name:"panchos", description:"hervir salchicas, cortaqr pan por el medio, poner la salchicha entre los panes, agregar condimentos a gusto", chef: @user)
  end

  test "successfully delete a recipe" do
    sign_in_as(@user, 'password')
    get recipe_path(@recipe)
    assert_template 'recipes/show'
    assert_select "a[href=?]", recipe_path(@recipe), text:"Delete"
    assert_difference 'Recipe.count', -1 do
      delete recipe_path(@recipe)
    end
    assert_redirected_to recipes_path
    assert_not flash.empty?
  end

end
