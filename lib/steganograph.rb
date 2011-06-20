# This is a simple class to encode any message in the BMP file.
# It takes each bit of the message and save it in the least significant bit of the image array,
# so that an output image looks exactly the same as original one and have the same size.   
# Encode:
# 
#   Steganograph.encode("image.bmp", "file_with_text.txt")    
#   
# Decode:
# 
#   message = Steganograph.decode("image.bmp")
  

class Steganograph
                       
   class << self    
       
       attr_reader :image, :image_array
   
       def load_text(file_name)
         file = File.open file_name, "r"
         @text = file.read.chars.inject("") { |str, chr| str += "%08b" % chr.ord }
       end
    
       def load_image(bmp_file)  
         @image = IO.read(bmp_file)
         @offset = @image[10..14].unpack('L*')[0]
         @image_array = @image[@offset..-1]         
       end  
       
       def load_files(bmp_file, file_name = nil)
          load_image(bmp_file)
          load_text(file_name) unless file_name.nil?
       end
            
      def create_image(image_array)
         @image[0..@offset-1] + image_array 
      end 
                         

    #    Bitwise operations:   
    #    x - position of the bit from 0 to 7
    # 
    #    Setting a bit
    #    number |= 1 << x
    #
    #    Clearing a bit
    #    number &= ~(1 << x)
    #
    #    Toggling a bit
    #    number ^= 1 << x
    #
    #    Checking a bit
    #    bit = number & (1 << x)
     
      
      def encode(bmp_file, file_name)
        load_files(bmp_file, file_name)   
        
        i = 0       
        encoded_image_array = @image_array.bytes.map do |byte|
            if i < @text.size
              if @text[i] == '1'   
                byte |= 1 << 0       
              elsif @text[i] == '0'
                byte &= ~(1 << 0)
              end
              i += 1    
            else
              byte &= ~(1 << 0)
            end     
            byte
         end                   
                                   
       File.open("output.bmp", "w") do |f|
         f.write  create_image(encoded_image_array.pack('C*').force_encoding('utf-8'))
       end
      
      end

      def decode(bmp_file)
        load_files(bmp_file)   
        decoded_string = @image_array.bytes.inject([]) { |string, byte| string << (byte & (1 << 0)) }                                                
        [decoded_string.join("")].pack('B*').unpack('A*')[0]                   
      end
    
   end     
end