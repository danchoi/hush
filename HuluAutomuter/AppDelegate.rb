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

  def muted
    puts "muting icon"
    status_item.image = @mute_icon
  end

  def unmuted
    puts "unmuting icon"
    status_item.image = @unmute_icon
  end

  def applicationDidFinishLaunching(a_notification)
    `ps aux | grep ruby | grep automuter-osx | awk '{print $2}' | xargs kill -INT`
    self.status_item = NSStatusBar.systemStatusBar.statusItemWithLength NSVariableStatusItemLength
    status_item.highlightMode = true
    @unmute_icon = NSImage.imageNamed "HA_hush_status_ON.png"
    @mute_icon = NSImage.imageNamed "HA_hush_status_MUTING.png"
    self.unmuted
    status_item.enabled = true
    status_item.toolTip = "HuluAutomuter"
    status_item.setAction :'statusClicked:'
    status_item.setTarget self
    automuter_path = NSBundle.mainBundle.pathForResource("automuter-osx", ofType:"")
    config_proxy
    self.task = NSTask.alloc.init
    task.setLaunchPath automuter_path
    #task.standardOutput = NSFileHandle.fileHandleWithStandardOutput
    configure_outpipe
    task.standardError = NSFileHandle.fileHandleWithStandardError
    task.launch
    @pid = task.processIdentifier
    puts "Process #@pid"
    
  end

  def configure_outpipe
    @outpipe = NSPipe.pipe
    self.task.standardOutput = @outpipe
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
      puts "PIPE STRING: #{string}"
      puts "END PIPE STRING"
      if string =~ /\[ad loaded\]/m
        self.muted
      elsif string =~ /\[content resuming\]/m
        self.unmuted
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

