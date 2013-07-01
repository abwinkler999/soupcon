require 'sinatra'
#require 'nokogiri'
require 'plist'

get '/' do
  erb :soupcon
end

get '/:recipe_id' do
  @recipe = @xmlDoc[params[:recipe_id]]
  erb :recipe
end

def loadRecipesList
  @recipesList = []
  Dir.foreach("assets") { |some_recipe|
    if some_recipe.include? ".ysr"
      recipeFile = File.new("assets/" + some_recipe);
      if recipeFile
        @xmlDoc = Plist::parse_xml(recipeFile) #hash of all recipes
        @xmlDoc.each { |x|
          @recipesList << x["name"]
        }
      else
        @recipesList << "No recipes found!"
      end
    end
  }
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
