#
#  AppDelegate.rb
#  HuluAutomuter
#
#  Created by Daniel Choi on 7/16/11.
#  Copyright 2011 __MyCompanyName__. All rights reserved.
#


NSLog `pwd `
NSLog `find .  `

automuter_path = NSBundle.mainBundle.pathForResource("hulu-automuter", ofType:"")
NSLog `ruby -e "puts 'hi'"`
`#{automuter_path} & `
pid_file = "#{ENV['HOME']}/hulu.pid"
pid = File.read pid_file
puts "PID: #{pid}"


class AppDelegate
    attr_accessor :window, :status_item
    def applicationDidFinishLaunching(a_notification)
        # Insert code here to initialize your application
      self.status_item = NSStatusBar.systemStatusBar.
        statusItemWithLength NSVariableStatusItemLength
      status_item.highlightMode = true
      status_item.title = "Hulu Automuter"
      status_item.enabled = true
      status_item.toolTip = "HuluAutomuter"
      status_item.setAction :'testAction:'
      status_item.setTarget self
      NSLog "hello"
    end

    def testAction(sender)
      NSLog "testAction"
    end

    def applicationWillTerminate(application)
      `kill -9 #{PID}`
    end
end

