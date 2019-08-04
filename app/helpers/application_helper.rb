module ApplicationHelper
    def random_message
        [
            'If you need help, go to the help section of the website.',
            'To use certain features, you need to be registered and logged in.',
            'An open source booru made with Rails!',
            'Download moeverdose source code on our github page!',
            'You can navigate between posts with your keyboard!',
            'Follow us on twitter and get the latest popular pics!',
            'Official team members are listed in the teams page.',
            'Get help for naming tags in the discord server.',
            'Want to participate with the community? Join the discord chat!',
            'Safe for work!',
            'Powered by cuteness!',
            "(\xEF\xBE\x89\xE2\x89\xA7\xDA\xA1\xE2\x89\xA6) Teehee~!",
            'All keyboard shortcuts are found in the help section.'
        ].sample
    end
end
