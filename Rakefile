require 'levenshtein'
require 'rake/testtask'
require 'yaml'

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
	words.each do |word|
		puts "Processing #{word}"
		if processed.include?(word)
			puts "Skipping as already processed."
			next
		end
		friends = []
		word_length = word.length
#		words.each do |stranger|
#			next unless ((word_length-1)..(word_length+1)).to_a.include?(stranger.length)
		#	perhaps a bit faster
		select_words = words.select{|w| ((word_length-1)..(word_length+1)).to_a.include?(w.length) }
		select_words.each do |stranger|
#
#	While this doesn't take long, it is the longest part of the process.
#	I'm also not interested in the actual distance, so I'd like to write
#	a "levenshtein_distance_to_greater_than_one?" method or
#	"levenshtein_distance_is_one?" method.
#	This method will simply return true or false
#

#			distance = word.levenshtein_distance_to(stranger) 
#			friends.push(stranger) if distance == 1	#	don't include self which would be 0

			if word.levenshtein_distance_is_one?(stranger)
				friends.push(stranger) 
			end
		end
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
