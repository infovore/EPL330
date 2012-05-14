== A library for EPL330-based LED matrix screens.


Complex example:

line1 = gl.string_for_text("Hide&Seek", :entry => :top, :exit => :bottom, :pause => 3)
line2 = gl.string_for_text("present", :entry => :left, :exit => :curtain, :pause => 2)
line3 = gl.string_for_text("The Building Is", :entry => :ends, :exit => :bottom, :pause => 3)
strings = [line1, line2, line3]
loop_strings(strings)
