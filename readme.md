A library for EPL330-based LED matrix screens.
==============================================

Initialise
----------

    epl = EPL330.new("192.168.5.60")

Simple example
--------------

    epl.loop_text("Hello, world!", :entry => :left, :exit => :right)

Complex example
---------------

    line1 = epl.string_for_text("Top to bottom", :entry => :top, :exit => :bottom, :pause => 3)
    line2 = epl.string_for_text("Left and vanish", :entry => :left, :exit => :curtain, :pause => 2)
    line3 = epl.string_for_text("Merge and drop", :entry => :ends, :exit => :bottom, :pause => 3)
    strings = [line1, line2, line3]
    epl.loop_strings(strings)
