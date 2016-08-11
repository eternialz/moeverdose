class RandomMessageCell < Cell::ViewModel

  def show
    number = rand(1..20)
    case number
    when 1
      @messages = "If you need help, go to the help section of the website"
    when 2
      @messages = "To upload, you need to be registered and logged in"
    when 3
      @messages = "An open source booru made with rails 5!"
    when 4
      @messages = 'Download moeverdose on our github page!'
    when 5
      @messages = "You can navigate between posts with your keyboard!"
    when 6
      @messages = "Pro Tip: Replace JS with CSS whenever you can!"
    when 7
      @messages = "Featuring invisible bunny spy from moon"
    when 8
      @messages = "All hail .moe domains!"
    when 9
      @messages = "Follow us on twitter and get the latest popular pics!"
    when 10
      @messages = "Want to participate with the community? Join the discord chat!"
    when 11
      @messages = "Safe for work!"
    when 12
      @messages = "Powered by cuteness!"
    when 13
      @messages = "Cute is justice!"
    when 14
      @messages = "Truck-san won't bring you to another world"
    when 15
      @messages = "Becoming stupid together since 2016"
    when 16
      @messages = "All kind of animal eared girls"
    when 17
      @messages = "You can read helpful tips here! Well.. not this time though"
    when 18
      @messages = "Moe overdoses kill more than sharks every years"
    when 19
      @messages = "Wanna join the team? Send us a message in the chat!"
    when 20
      @messages = "Plase don't abuse the report system!"
    end
  end

end
