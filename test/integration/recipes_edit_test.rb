require 'test_helper'

class RecipesEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = Chef.create!(chefname: "Androba", email: "amdres@mail.com")
    @recipe = Recipe.create(name:"panchos", description:"hervir salchicas, cortaqr pan por el medio, poner la salchicha entre los panes, agregar condimentos a gusto", chef: @user)
  end

  test "reject invalid recipe update" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    patch recipe_path(@recipe), params: {recipe: {name:"",description:"some stupid description"}}
    assert_template 'recipes/edit'
    assert_select "h2.panel-title"
    assert_select "div.panel-body"
  end

  test "successfully edit a recipe" do
    get edit_recipe_path(@recipe)
    assert_template 'recipes/edit'
    updated_name = "new name"
    updated_description = "new more awesome description"
    patch recipe_path(@recipe), params: {recipe: {name:updated_name,description:updated_description}}
    assert_redirected_to @recipe
    assert_not flash.empty?
    @recipe.reload
    assert_match updated_name, @recipe.name
    assert_match updated_description, @recipe.description
  end
end
