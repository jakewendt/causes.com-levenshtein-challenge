require 'levenshtein'
require 'rake/testtask'
require 'yaml'
require 'benchmark'

desc 'Default: run unit tests.'
task :default => :test

desc 'Run the levenshtein tests.'
Rake::TestTask.new(:test) do |t|
	t.libs << 'test'
	t.pattern = 'test/**/*_test.rb'
	t.verbose = true
end

desc "Compute Levenshtein distance between 2 words. (case sensitive)"
task :levenshtein_distance do
	args = $*.dup.slice(1..-1)
	if args.length != 2
		puts
		puts "2 words required"
		puts "Usage: rake #{$*} [word1] [word2]"
		puts
		exit
	end
	distance = args[0].levenshtein_distance_to(args[1])
	puts "Levenshtein distance between #{args[0]} and #{args[1]} is #{distance}"
	exit	#	MUST exit, otherwise rake attempts to run tasks of the words
end


#	As this will take quite a while, may want to devise a way to pause and continue
#	May also want to write the results of each search to the file immediately
#	rather than wait until the end.

task :build_network do
#	words = File.readlines('levenshtein.list').collect(&:chomp!)[0..9999]

#	Not only is this the list of word to look for friends, 
#	it is the list of potential friends!
#	Shortening it, will shorten both.  
	words = File.readlines('levenshtein.list').collect(&:chomp!)

	processed = if File.exists?('network.yml') && ( network = YAML::load(IO.read( 'network.yml') )).is_a?(Hash)
		network.keys 
	else
		[]
	end

	f = File.open('network.yml', "a")

	#	Processing each word can take about 5 seconds,
	#	so processing 264061 words can take quite a while.
	#	That would be 1320305 seconds
	#	Or 22005 minutes
	#	Or 366 hours
	#	Or 15 days.  Seriously?  2 weeks!
	#	Even a 1 second a word, that's still 3 straight days of processing.
#
#	This has gotten out of control.  
#	With the full list, it is now taking ~30 seconds a word.
#	That is potentially 3 months!!!
#
	words.each do |word|
		if processed.include?(word)
			puts "Skipping #{word} already processed."
			next
		else
			printf "Processing #{word}. " #	use printf so time is on same line
		end
		friends = []
#		word_length = word.length
#
#	levenshtein_distance == 1
#Processing apiol
#219.270000   0.750000 220.020000 (221.079529)
#
#	old_levenshtein_distance_is_one?
#Processing apimanias
#119.910000   0.420000 120.330000 (120.864198)
#
#	new levenshtein_distance_is_one?
#Processing apiculture
#  8.240000   0.740000   8.980000 (  9.070253)
#
		time = Benchmark.measure{
		words.each do |stranger|
#		select_words = words.select{|w| ((word_length-1)..(word_length+1)).to_a.include?(w.length) }
#		select_words.each do |stranger|
#
#	While this doesn't take long, it is the longest part of the process.
#	I'm also not interested in the actual distance, so I'd like to write
#	a "levenshtein_distance_to_greater_than_one?" method or
#	"levenshtein_distance_is_one?" method.
#	This method will simply return true or false
#
#			friends.push(stranger) if word.levenshtein_distance_to(stranger) == 1        #  don't include self which would be 0
#			friends.push(stranger) if word.old_levenshtein_distance_is_one?(stranger)    #	0.0005
			friends.push(stranger) if word.levenshtein_distance_is_one?(stranger)        #	0.00002 (about 10-20 times faster, but still slow)
		end
		} #		Benchmark.measure{
		#	between 5 and 8 seconds.  Fast considering, but still slow.  
		#	265000 * 5 seconds ~ 370 hours ~ 2 weeks!
		#	
		puts time.real	

		#	In order to allow to stopping and restarting, write the data as we get it.
		#	Using to_yaml doesn't quite work as desired, so do it by hand.  
		#	Not really that complicated.
		if friends.empty?
			f.puts("#{word}: []")
		else
			f.puts("#{word}:")
			f.puts(friends.collect{|w| "- #{w}"})
		end
	end
	f.close
end

desc "Display the levenshtein friends of the given word."
task :friends_of do
	args = $*.dup.slice(1..-1)
	if args.length == 0
		puts
		puts "Word required"
		puts "Usage: rake #{$*} [word]"
		puts
		exit
	end
	args.each do |word|
		puts "Searching for friends of ... #{word}"
		network = YAML::load(IO.read( 'network.yml') )
		puts network[word].inspect
	end
	exit	#	MUST exit, otherwise rake attempts to run tasks of the words
end




desc "Find and Display the levenshtein friends of the given word."
task :find_friends_of do
	args = $*.dup.slice(1..-1)
	if args.length == 0
		puts
		puts "Word required"
		puts "Usage: rake #{$*} [word]"
		puts
		exit
	end
	args.each do |me|
		puts "Searching for friends of ... #{me}"
		puts "Loading strangers list"
		strangers = File.readlines('levenshtein.list').collect(&:chomp!)
		puts "Done loading strangers list"
		strangers << me unless strangers.include?(me)
		network = []
		unsearched = [strangers.delete(me)]

		begin 
			searching = unsearched.shift
			network.push( searching )
			puts "Searching for friends of #{searching}"
			puts "Current strangers count:#{strangers.length}"
			puts "Current network count:#{network.length}"
			puts "Current unsearched count:#{unsearched.length}"

			strangers.each do |w|
				if searching.levenshtein_distance_is_one?(w)
					puts "--:#{searching}:#{w}:"
					unsearched.push(strangers.delete(w))	#	not a stranger anymore so remove from the list and don't check anymore
				end
			end

		end while unsearched.length > 0

		puts "All Done."
		puts "Final Network Count:#{network.length} (includes #{me})"
		puts "Final Stranger Count:#{strangers.length}"
	end
	exit	#	MUST exit, otherwise rake attempts to run tasks of the words
end
