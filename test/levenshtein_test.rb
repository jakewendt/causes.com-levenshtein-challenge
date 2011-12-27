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
		assert !'Sunday'.levenshtein_distance_is_one?('Saturday')	#	length longer by more than 1
	end

	test "Sunday distance to Saturday is not one" do
		assert !'Saturday'.levenshtein_distance_is_one?('Sunday')	#	length longer by more than 1
	end


	test "apple distance to apples is one" do
		assert 'apple'.levenshtein_distance_is_one?('apples')	#	1 additional letter at end
	end

	test "apple distance to sapple is one" do
		assert 'apple'.levenshtein_distance_is_one?('sapple')	#	1 additional letter at beginning
	end

	test "apple distance to appsle is one" do
		assert 'apple'.levenshtein_distance_is_one?('appsle')	#	1 additional letter in middle
	end


	test "apples distance to apple is one" do
		assert 'apples'.levenshtein_distance_is_one?('apple')	#	1 less letter at end
	end

	test "sapple distance to apple is one" do
		assert 'sapple'.levenshtein_distance_is_one?('apple')	#	1 less letter at beginning
	end

	test "appsle distance to apple is one" do
		assert 'appsle'.levenshtein_distance_is_one?('apple')	#	1 less letter in middle
	end


	test "simple distance to pimple is one" do
		assert 'simple'.levenshtein_distance_is_one?('pimple')	#	1 changed letter at beginning
	end

	test "simple distance to sample is one" do
		assert 'simple'.levenshtein_distance_is_one?('sample')	#	1 changed letter in middle
	end



	test "'apple'.diff_count('apple') should return 0" do
		assert_equal 'apple'.diff_count('apple'), 0
	end

	test "'apple'.diff_count('apxle') should return 1" do
		assert_equal 'apple'.diff_count('apxle'), 1
	end



	test "[1,2,3].diff_count([1,2,3]) should return 0" do
		assert_equal ([1,2,3].diff_count([1,2,3])), 0
	end

	test "[1,2,3].diff_count([1,2,4]) should return 1" do
		assert_equal ([1,2,3].diff_count([1,2,4])), 1
	end

	test "[1,2,3].diff_count([1,3,4]) should return 2" do
		assert_equal ([1,2,3].diff_count([1,3,4])), 2
	end


end
