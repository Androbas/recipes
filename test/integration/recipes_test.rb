require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Androba", email: "amdres@mail.com")
    @recipe = Recipe.create(name:"panchos", description:"hervir salchicas, cortaqr pan por el medio, poner la salchicha entre los panes, agregar condimentos a gusto", chef: @user)
    @recipe2 = @user.recipes.build(name:"pollo", description: "cocinar pollo")
    @recipe2.save
  end

  test "should get recipes index" do
    get recipes_url
    assert_response :success
  end

  test "should list all recipes" do
    get recipes_path
    assert_template "recipes/index"
    assert_match @recipe.name, response.body
    assert_match @recipe2.name, response.body

  end
end
