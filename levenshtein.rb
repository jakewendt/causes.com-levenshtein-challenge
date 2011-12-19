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

	#	Basically being computing the distance and if the mins are ever
	#	all greater than 1, return false.
	def levenshtein_distance_is_one?(word='')
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
