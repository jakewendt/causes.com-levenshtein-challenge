require 'test_helper'

class LevenshteinTest < Test::Unit::TestCase

	test "kitten should be 3 from sitting" do
		assert_equal 3, 'sitting'.levenshtein_distance_to('kitten')
	end

	test "Saturday should be 3 from Sunday" do
		assert_equal 3, 'Sunday'.levenshtein_distance_to('Saturday')
	end

	test "kitten distance to sitting is not one" do
		assert !'sitting'.levenshtein_distance_is_one?('kitten')
	end

	test "Saturday distance to Sunday is not one" do
		assert !'Sunday'.levenshtein_distance_is_one?('Saturday')
	end

	test "apple distance to apples is one" do
		assert 'apple'.levenshtein_distance_is_one?('apples')
	end

end
