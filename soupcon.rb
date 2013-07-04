require 'sinatra'
#require 'nokogiri'
require 'plist'
require 'better_errors'

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
  Dir.foreach("assets") { |some_recipe|
    if some_recipe.include? ".ysr"
      recipeFile = File.new("assets/" + some_recipe);
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
  puts "Recipes array size: "+ @recipes.length.to_s
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

def displayRecipe
  returnString = ""
  returnString << "<h1>" + @recipe["name"] + "</h1>"
  returnString << '<div id="directions">' + @recipe["directions"] + '</div>'
  #@recipe.each {|key, value|
  #  if key == "directions"
  #    returnString << '<div id="directions">' + value + '</div>'
  #  else
  #    returnString << "<p>#{key} : #{value} </p>"
  #  end
  
  return returnString
end
