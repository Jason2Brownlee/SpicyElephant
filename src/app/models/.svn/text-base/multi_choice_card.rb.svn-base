class MultiChoiceCard < Card
  def question
    #read "stuff[list][*]abc[*]def[*]ghi[/list]otherstuff"
    text = read_attribute('question')
    
    #find the first list [["[*]abc[*]def[*]ghi"]] 
    options = text.scan(/\[choices\](.*)\[\/choices\]/)
    if options.length > 0 
      
      #get the string for the first list bullets if a list was found. "[*]abc[*]def[*]ghi"
      options = options[0][0]
      
      #get an array of all the bullet options ["abc","def","ghi"]
      options = options.scan(/\[\*(?:\s*)]\s*([^\[]*)/).*.at(0)
      
      #create form with bunch of radio buttons.
      ques = "<form name=\"myform\" action=\"http://www.mydomain.com\""
      options.each do |option|
        ques += "<input type=\"radio\" name=\"chioce\" value=\"#{option}\">#{option}</input>"
      end
      ques += "</form>"
      return ques
    else
      "error"
    end
  end
end

