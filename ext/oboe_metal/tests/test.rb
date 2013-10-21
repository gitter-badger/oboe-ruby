# Copyright (c) 2013 AppNeta, Inc.
# All rights reserved.

require 'oboe'

r = Oboe::UdpReporter.new('127.0.0.1')
Oboe::Context.init()
e = Oboe::Context.createEvent()
e.addInfo("TestKey", "TestValue")
r.sendReport(e)

