Array.class_eval do

	def diff_count(array)
		count = 0
		self.each_with_index do |x,i| 
#			count += 1 if self[i] != array[i]
			count += 1 if x != array[i]
		end
		count
	end

end

String.class_eval do

	#	modified from http://en.wikipedia.org/wiki/Levenshtein_distance
	#	BEWARE: this list and comparison is case sensitive
	def levenshtein_distance_to(word='')
		m = self.length
		n = word.length
		d = Array.new(m+1){Array.new(n+1)}

		(0..m).each { |i| d[i][0] = i }
		(0..n).each { |j| d[0][j] = j }

		(1..m).each { |i|
			(1..n).each { |j|
				if self.chars.to_a[i-1] == word.chars.to_a[j-1]
					d[i][j] = d[i-1][j-1]
				else
					d[i][j] = [
						d[i-1][j] + 1,		#	a deletion
						d[i][j-1] + 1,		#	an insertion
						d[i-1][j-1] + 1		#	a substitution
					].min
				end
			}
		}
		d[d.length-1][d[0].length-1]
	end

	def diff_count(word)
		self.chars.to_a.diff_count(word.chars.to_a)
	end

	def levenshtein_distance_is_one?(word='')
		m = self.chars.to_a
		n = word.chars.to_a
		length_difference = self.length - word.length
		case length_difference.abs
			when 0
				return self.diff_count(word) == 1
			when 1
#	a = 'apple'; b='appsle'
#a.match(/#{b.chars.collect{|l|"(#{l}?).*?"}.join}/).to_a
#=> ["apple", "a", "p", "p", "l", "e"]
				long,short = ( self.length > word.length ) ? [self,word] : [word,self]
#				return short.match(/#{long.chars.collect{|l|"(#{l}?).*?"}.join}/)[0] == short
				return short.match(/#{long.chars.collect{|l|"#{l}?.*?"}.join}/)[0] == short
			else
				return false 
		end
	end

	#	Basically being computing the distance and if the mins are ever
	#	all greater than 1, return false.
	def old_levenshtein_distance_is_one?(word='')
		m = self.length
		n = word.length
		d = Array.new(m+1){Array.new(n+1)}

		(0..m).each { |i| d[i][0] = i }
		(0..n).each { |j| d[0][j] = j }

		(1..m).each { |i|
			(1..n).each { |j|
				if self.chars.to_a[i-1] == word.chars.to_a[j-1]
					d[i][j] = d[i-1][j-1]
				else
					d[i][j] = [
						d[i-1][j] + 1,		#	a deletion
						d[i][j-1] + 1,		#	an insertion
						d[i-1][j-1] + 1		#	a substitution
					].min
				end
			}
			#	if the minimum of a row is ever greater than 1, don't bother checking anymore
			return false if d[i].min > 1
		}
#		d[d.length-1][d[0].length-1]
		d[d.length-1][d[0].length-1] == 1
	end

end
