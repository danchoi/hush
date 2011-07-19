#
#  AppDelegate.rb
#  HuluAutomuter
#
#  Created by Daniel Choi on 7/16/11.
#  Copyright 2011 __MyCompanyName__. All rights reserved.
#


class AppDelegate
  attr_accessor :window, :status_item, :task, :file
  def applicationDidFinishLaunching(a_notification)
      # Insert code here to initialize your application
    `killall automuter-osx`
    self.status_item = NSStatusBar.systemStatusBar.
      statusItemWithLength NSVariableStatusItemLength
    status_item.highlightMode = true
    status_item.title = "Hulu Automuter"
    status_item.enabled = true
    status_item.toolTip = "HuluAutomuter"
    status_item.setAction :'testAction:'
    status_item.setTarget self
    automuter_path = NSBundle.mainBundle.pathForResource("automuter-osx", ofType:"")
    NSLog `ruby -v`
    # `#{automuter_path} & `
    #pid_file = "#{ENV['HOME']}/hulu.pid"
    #pid = File.read pid_file
    #puts "PID: #{pid}"

    self.task = NSTask.alloc.init
    output = NSPipe.alloc.init
    error = NSPipe.alloc.init

    task.setLaunchPath automuter_path
    task.setStandardOutput output
    task.setStandardError error

    task.launch
    pid = task.processIdentifier
    puts "PID: #{pid}"

  end

  def testAction(sender)
    NSLog "testAction"
  end

  def applicationWillTerminate(application)
    self.task.terminate
    `killall automuter-osx`
  end
end

