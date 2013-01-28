require 'sinatra'
require 'nokogiri'

get '/' do
  erb :soupcon
end

def readRecipe
  Dir.foreach("assets") { |some_recipe|
    if some_recipe.include? ".ysr"
      recipeFile = File.new("assets/" + some_recipe);
      if recipeFile
      #IO.foreach("ravens.are") { |line| @area << line }
        #IO.foreach(recipeFile) { |line| masterReturnString << line }
        @xmlDoc = Nokogiri::XML(recipeFile)
      else
        puts "File could not be opened!"
      end
    end
  }
end

def returnSomething
  #returnString = Array.new
  #@xmlDoc.xpath('//*').each do |elem|
   # returnString << "Object Type: " + elem.class.to_s + " Name: " + elem +  " Key: " + elem.keys.to_s +  " Value: " + elem.values.to_s + "\n\r"
  #end
  #puts @xmlDoc.root
  puts "Thing: " + @xmlDoc.xpath("//color")[0].to_s
  return @xmlDoc.xpath("//color")
end