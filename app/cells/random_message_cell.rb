class RandomMessageCell < Cell::ViewModel

  def show
    [
      "If you need help, go to the help section of the website",
      "To use certain features, you need to be registered and logged in",
      "An open source booru made with rails 5!",
      'Download moeverdose source code on our github page!',
      "You can navigate between posts with your keyboard!",
      "Follow us on twitter and get the latest popular pics!",
      "Want to participate with the community? Join the discord chat!",
      "Safe for work!",
      "Powered by cuteness!",
      "(ﾉ≧ڡ≦) Teehee~!",
      "All keyboard shortcuts are found in the help section"
    ].sample
  end
end
