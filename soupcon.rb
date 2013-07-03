require 'sinatra'
#require 'nokogiri'
require 'plist'
require 'better_errors'

before do
  loadRecipesList
end

get '/' do
  erb :soupcon
end

get '/recipes/:recipe_id' do
  i = params[:recipe_id].to_i
  #puts "************ ---------->" + i.class.to_s
  #puts "************ ---------->" + @recipes.class.to_s
  #puts @xmlDoc.inspect
  @recipe = @recipes[i]
  erb :foo
end

# TO DO:  @xmlDoc is apparently loading a hash of all recipes.  For the index page, soupcon is extracting a list of all
# "name" key-value pairs and just rendering them into an array of names.  Useful to display, but doesn't point back to
# the original hash.  What is needed is to take the hash and turn it into an array of hashes (i.e. each recipe becomes
# an array entry).  Then the array index will point to an individual recipe.


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
          #@recipeNamesList << x["name"]
          #puts x["name"]
          #puts "***************"
          #puts x
          #puts "***************"
        }
      else
        #@recipeNamesList << "No recipes found!"
      end
    end
  }
  puts "Recipes array size: "+ @recipes.length.to_s
  #puts "Recipes item no. 7: " + @recipes[6].to_s
  #return @recipesList
end

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

def returnSomething
  returnString = ""
  #returnString = Array.new
  # @xmlDoc.xpath('//*').each do |elem|
   # returnString << "Object Type: " + elem.class.to_s + " Name: " + elem +  " Key: " + elem.keys.to_s +  " Value: " + elem.values.to_s + "\n\r"
  #end
  #puts Plist::Emit.dump(@xmlDoc)
  returnString << "<h1>" + @recipe["name"] + "</h1>"
  returnString << '<div id="directions">' + @recipe["directions"] + '</div>'
  #@recipe.each {|key, value|
  #  if key == "directions"
  #    returnString << '<div id="directions">' + value + '</div>'
  #  else
  #    returnString << "<p>#{key} : #{value} </p>"
  #  end
  
  return returnString
  #return "<p>Attribution: " + @recipe['attribution'] + "</p><p>Directions: " + @recipe['directions'] + "</p>" + @recipe['cuisine']
  #return @recipe.inspect

end
