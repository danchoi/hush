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
    
    `ps aux | grep ruby | grep automuter-osx | awk '{print $2}' | xargs kill -INT`
    self.status_item = NSStatusBar.systemStatusBar.statusItemWithLength NSVariableStatusItemLength
    status_item.highlightMode = true
    status_item.title = "Hulu Automuter"
    status_item.enabled = true
    status_item.toolTip = "HuluAutomuter"
    status_item.setAction :'statusClicked:'
    status_item.setTarget self
    automuter_path = NSBundle.mainBundle.pathForResource("automuter-osx", ofType:"")
    config_proxy
    self.task = NSTask.alloc.init
    task.setLaunchPath automuter_path
    #task.standardOutput = NSFileHandle.fileHandleWithStandardOutput
    @outpipe = NSPipe.pipe
    task.standardOutput = @outpipe
    task.standardError = NSFileHandle.fileHandleWithStandardError
    puts task.launch
    @pid = task.processIdentifier
    puts "Process #@pid"

    
    NSNotificationCenter.defaultCenter.addObserver self,
      selector: :'readPipe:',
      name: "NSFileHandleReadCompletionNotification",
      object: @outpipe.fileHandleForReading
    @outpipe.fileHandleForReading.readInBackgroundAndNotify
  end

  def readPipe(notification)
    data = notification.userInfo.objectForKey NSFileHandleNotificationDataItem
    if data.length
      string = NSString.alloc.initWithData data, encoding: NSUTF8StringEncoding
      if string =~ /\[ad loaded\]/
        self.status_item.title = "muting"
      elsif string =~ /\[content resuming\]/
        self.status_item.title = "un muting"
      end
      notification.object.readInBackgroundAndNotify
    end
  end

  def statusClicked(sender)
    NSLog "statusClicked"
  end

  # NSFileHandleConnectionAcceptedNotification
  #

  def applicationWillTerminate(application)
    self.task.interrupt
    self.task.waitUntilExit
    unconfig_proxy
  end
end

