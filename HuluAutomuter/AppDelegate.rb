#  HuluAutomuter
#  Created by Daniel Choi on 7/16/11.
#  License: MIT License (c) 2011 Daniel Choi

class AppDelegate
  attr_accessor :window, :status_item, :task, :file

  def config_proxy
    path = NSBundle.mainBundle.pathForResource("automuter", ofType:"pac")
    path = "file://localhost" + path
    cmd = "networksetup -setautoproxyurl AirPort #{path}"
    puts cmd
    `#{cmd}`
  end

  def unconfig_proxy
    path = NSBundle.mainBundle.pathForResource("automuter_off", ofType:"pac")
    path = "file://localhost" + path
    cmd = "networksetup -setautoproxyurl AirPort #{path}"
    #cmd = "networksetup -setwebproxystate AirPort off"
    puts cmd
   `#{cmd}`
  end

  LOGFILE = `#{ENV['HOME']}/.automuter/automuter.log`
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
    cmd = "#{automuter_path} >> #{LOGFILE}"
    puts cmd
    puts `#{cmd}`
  end

  def statusClicked(sender)
    NSLog "statusClicked"
  end

  def applicationWillTerminate(application)
    `kill -INT #{@pid}`
    unconfig_proxy
  end
end

