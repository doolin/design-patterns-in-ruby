#!/usr/bin/env ruby

# This is an X11 application, will run on OSX with XQuartz.

require 'fox16'

include Fox

application = FXApp.new("CompositeGUI", 'CompositeGUI')
main_window = FXMainWindow.new(application, "Composite", nil, nil, DECOR_ALL)
main_window.width = 600
main_window.height = 400

application.create
main_window.show(PLACEMENT_SCREEN)
application.run
