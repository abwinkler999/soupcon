require 'sinatra'
require 'plist'
require 'better_errors'

set :root, File.join(File.dirname(__FILE__), '..')
set :views, Proc.new { File.join(root, "app/views") }

# replace this eventually with a proper PostgreSQL backend
before do
  loadRecipesList
end

get '/' do
  erb :soupcon
end

get '/recipes/:recipe_id' do
  i = params[:recipe_id].to_i
  @recipe = @recipes[i]
  erb :recipe
end

get '/structure/:recipe_id' do
  i = params[:recipe_id].to_i
  @recipe = @recipes[i]
  erb :structure
end

def loadRecipesList
  #@recipeNamesList = []
  @recipes = []
  Dir.foreach("../app/assets") { |some_recipe|
    if some_recipe.include? ".ysr"
      recipeFile = File.new("../app/assets/" + some_recipe);
      if recipeFile
        @xmlDoc = Plist::parse_xml(recipeFile) #hash of all recipes
        @xmlDoc.each { |x|
          @recipes << x
        }
      else
        #@recipeNamesList << "No recipes found!"
      end
    end
  }
end

# DEPRECATED
def readRecipe
  Dir.foreach("assets") { |some_recipe|
    if some_recipe.include? ".bak"
      recipeFile = File.new("assets/" + some_recipe);
      if recipeFile
        @xmlDoc = Plist::parse_xml(recipeFile)
        # for some reason, creates array with one element -- the hash
        @recipe = @xmlDoc[0]
        #puts @recipe.class
        @recipe["RecipeName"] = some_recipe.to_s
        @recipe.each { |x, y| puts "#{x} is #{y}"}
      else
        puts "File could not be opened!"
      end
    end
  }
end
