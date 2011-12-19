require 'test_helper'

class LevenshteinTest < Test::Unit::TestCase

	test "kitten should be 3 from sitting" do
		assert_equal 3, 'sitting'.levenshtein_distance_to('kitten')
	end

	test "Saturday should be 3 from Sunday" do
		assert_equal 3, 'Sunday'.levenshtein_distance_to('Saturday')
	end

end
