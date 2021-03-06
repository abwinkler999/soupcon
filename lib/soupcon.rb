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

#ingredients are stored in a peculiar format.  Need to convert these to displayable strings.
def parseIngredient(raw)
  name = ""
  quantity = 0
  measurement = ""
  prep_method = ""

  jooky = raw.tr('=', ',')
  if jooky.class != String
      puts "*******************"
      puts jooky.class
  end
  jooky = jooky.tr!(';', ',')
  jooky = jooky.tr!('{', ' ')
  jooky = jooky.tr!('}', ' ')
  jooky.strip!.slice!(-1)
  result = jooky.split(',')
  result.each { |x| 
    x.tr!('""', ' ')
    x.strip!
  }
  result_hash = Hash[*result.flatten]

  result_string = ""
  result_hash.delete_if {|key, value| value == ""}
  if result_hash.has_key?("quantity")
    result_string << result_hash["quantity"] + " "
  end
  
  if result_hash.has_key?("measurement")
    result_string << result_hash["measurement"] + " "
  end
  
  if result_hash.has_key?("name")
    result_string << result_hash["name"]
  end
  
  if result_hash.has_key?("method")
    result_string << ", " + result_hash["method"]
  end
  
  return result_string

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
