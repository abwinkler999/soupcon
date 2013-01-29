require 'sinatra'
#require 'nokogiri'
require 'plist'

get '/' do
  erb :soupcon
end

def readRecipe
  Dir.foreach("assets") { |some_recipe|
    if some_recipe.include? ".bak"
      recipeFile = File.new("assets/" + some_recipe);
      if recipeFile
        @xmlDoc = Plist::parse_xml(recipeFile)
        # for some reason, creates array with one element -- the hash
        @resultingHash = @xmlDoc[0]
        #puts @resultingHash.class
        @resultingHash["RecipeName"] = some_recipe.to_s
        #puts @resultingHash["RecipeName"]
      else
        puts "File could not be opened!"
      end
    end
  }
end

def returnSomething
  returnString = ""
  #returnString = Array.new
  #@xmlDoc.xpath('//*').each do |elem|
   # returnString << "Object Type: " + elem.class.to_s + " Name: " + elem +  " Key: " + elem.keys.to_s +  " Value: " + elem.values.to_s + "\n\r"
  #end
  #puts Plist::Emit.dump(@xmlDoc)
  returnString << "<h1>" + @resultingHash["name"] + "</h1>"
  @resultingHash.each {|key, value|
    if key == "directions"
      returnString << '<div id="directions">' + value + '</div>'
    else
      returnString << "<p>#{key} : #{value} </p>"
    end
  }
  return returnString
  #return "<p>Attribution: " + @resultingHash['attribution'] + "</p><p>Directions: " + @resultingHash['directions'] + "</p>" + @resultingHash['cuisine']
  #return @resultingHash.inspect

  #return "!"
end