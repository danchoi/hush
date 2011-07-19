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
    self.status_item = NSStatusBar.systemStatusBar.
      statusItemWithLength NSVariableStatusItemLength
    status_item.highlightMode = true
    status_item.title = "Hulu Automuter"
    status_item.enabled = true
    status_item.toolTip = "HuluAutomuter"
    status_item.setAction :'statusClicked:'
    status_item.setTarget self
    automuter_path = NSBundle.mainBundle.pathForResource("automuter-osx", ofType:"")
    `mkdir #{ENV['HOME']}/.automuter`
    `rm #{ENV['HOME']}/.automuter/automuter.log`
    `touch #{ENV['HOME']}/.automuter/automuter.log`
    cmd = "#{automuter_path} > #{ENV['HOME']}/.automuter/automuter.log 2>&1 &"
    puts cmd
    puts `#{cmd}`
    return

    self.task = NSTask.alloc.init
    @log_path = "#{ENV['HOME']}/.automuter/automuter.log"
    @output = NSFileHandle.fileHandleForWritingAtPath @log_path
    if @output.nil?
      puts "Failed to open stdout path #@log_path"
    end
    puts @output.class
    task.setLaunchPath automuter_path
    task.setStandardOutput @output
    #task.setStandardError @output
    task.launch
    @pid = task.processIdentifier
    puts task.standardOutput
    puts "PID: #{@pid}"
  end

  def statusClicked(sender)
    NSLog "statusClicked"
  end

  def applicationWillTerminate(application)
    `kill -INT #{@pid}`
  end
end

