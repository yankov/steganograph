require File.expand_path(File.join(File.dirname(__FILE__), "..","lib", "steganograph"))

describe "Steganorgraph" do  
  
  before(:all) do   
    @input_file = File.expand_path(File.join(File.dirname(__FILE__), "..", "sample_input.txt"))
    @input_image = File.expand_path(File.join(File.dirname(__FILE__), "..", "input.bmp"))                
    @output_image = File.expand_path(File.join(File.dirname(__FILE__), "..", "output.bmp"))
    @sample_output_image = File.expand_path(File.join(File.dirname(__FILE__), "..", "sample_output.bmp"))
  end

  it "should read a file and convert text to a binary" do
    @text =  Steganograph.load_text(@input_file)
    @text.should == "010010000110010101101100011011000110111100100000010101110110111101110010011011000110010000001010" 
  end            
  
  it "should load an image" do
    Steganograph.load_image(@input_image)
    Steganograph.image.should_not == nil
    Steganograph.image_array.should_not == nil
  end                                             
  
  it "should create output.bmp equal to sample_output.bmp" do
    Steganograph.encode(@input_image, @input_file)            
    difference = `diff -b #{@output_image} #{@sample_output_image}`
    difference.should == ""                            
  end                                              
  
  it "should decode message from the image" do
    message = Steganograph.decode(@sample_output_image)
    message.should == "Hello World\n"
  end
  
end