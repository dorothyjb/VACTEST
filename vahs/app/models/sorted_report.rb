class SortedReport
	attr_accessor :information

	def get_ro
		output = Hash.new {|h,k| h[k] = Array.new }
		information.each do |i|
		  if (output.key?(i[18]))  #if ro is already in hash
      	  {
            output[i[18]] => output[i[18]].push(i) #append to array
          }
          else
          {
            output[i[18]] => [i] #make new key/value
          }
      end
    end
    return output
  end
end