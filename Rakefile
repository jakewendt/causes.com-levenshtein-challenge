require 'levenshtein'
require 'rake/testtask'
require 'yaml'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test this.'
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
	words = File.readlines('levenshtein.list').collect(&:chomp!)[0..999]
	network = {}
	words.each do |word|
		puts "Processing #{word}"
		network[word] = []
		word_length = word.length
		words.each do |stranger|
			next unless ((word_length-1)..(word_length+1)).to_a.include?(stranger.length)
			distance = word.levenshtein_distance_to(stranger) 
			network[word].push(stranger) if distance == 1	#	don't include self which would be 0
		end
	end

#	just one big write?  Hmm.

	f = File.open('network.yml', "w")
	f.write(network.to_yaml)
	f.close
end

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
