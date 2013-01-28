require 'sinatra'
get '/' do
  erb :soupcon
end

def returnSomething
  masterReturnString = ""
  Dir.foreach("assets") { |some_recipe|
    if some_recipe.include? ".ysr"
      recipeFile = File.new("assets/" + some_recipe);
      if recipeFile
      #IO.foreach("ravens.are") { |line| @area << line }
        IO.foreach(recipeFile) { |line| masterReturnString << line }
      else
        puts "File could not be opened!"
      end
    end
  }
  return masterReturnString;
end
  
