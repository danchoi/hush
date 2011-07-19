#  HuluAutomuter
#  Created by Daniel Choi on 7/16/11.
#  License: MIT License (c) 2011 Daniel Choi

class AppDelegate
  attr_accessor :window, :status_item, :task, :file

  VERSION = '0.0.1'

  def run(cmd)
    puts cmd
    `#{cmd}`
  end

  def config_proxy
    path = NSBundle.mainBundle.pathForResource("automuter", ofType:"pac")
    path = "file://localhost" + path
    u = NSBundle.mainBundle.URLForResource("automuter", withExtension:"pac")
    puts path
    puts "URL: #{u}"
    run "networksetup -setautoproxyurl AirPort #{path}"
    run "networksetup -setautoproxyurl Ethernet #{path}"
  end

  def unconfig_proxy
    path = NSBundle.mainBundle.pathForResource("automuter_off", ofType:"pac")
    path = "file://localhost" + path
    run "networksetup -setautoproxyurl AirPort #{path}"
    run "networksetup -setautoproxyurl Ethernet #{path}"
  end

  def applicationDidFinishLaunching(a_notification)
      # Insert code here to initialize your application
    self.status_item = NSStatusBar.systemStatusBar.statusItemWithLength NSVariableStatusItemLength
    status_item.highlightMode = true
    status_item.title = "Hulu Automuter"
    status_item.enabled = true
    status_item.toolTip = "HuluAutomuter"
    status_item.setAction :'statusClicked:'
    status_item.setTarget self
    automuter_path = NSBundle.mainBundle.pathForResource("automuter-osx", ofType:"")
    config_proxy
    `mkdir #{ENV['HOME']}/.automuter`
    @logfile = "#{ENV['HOME']}/.automuter/hulu.log"
    # & doesn't work
    #run "#{automuter_path} >> #{@logfile} 2>&1 &"
    task = NSTask.alloc.init
    task.setLaunchPath automuter_path
    task.standardOutput = NSFileHandle.fileHandleWithStandardOutput
    task.standardError = NSFileHandle.fileHandleWithStandardError
    puts task.launch
  end

  def statusClicked(sender)
    NSLog "statusClicked"
  end

  def applicationWillTerminate(application)
    `kill -INT #{@pid}`
    unconfig_proxy
  end
end

