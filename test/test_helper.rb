require 'test/unit'
require 'levenshtein'


#	from active support
module Declarative
	# test "verify something" do
	#   ...
	# end
	def test(name, &block)
		test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
		defined = instance_method(test_name) rescue false
		raise "#{test_name} is already defined in #{self}" if defined
		if block_given?
			define_method(test_name, &block)
		else
			define_method(test_name) do
				flunk "No implementation provided for #{name}"
			end
		end
	end


	def test_with_verbosity(name,&block)
		test_without_verbosity(name,&block)

		test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
		define_method("_#{test_name}_with_verbosity") do
#			print "\n#{self.class.name.gsub(/Test$/,'').titleize} #{name}: "
			print "\n#{self.class.name.gsub(/Test$/,'')} #{name}: "
			send("_#{test_name}_without_verbosity")
		end
		#
		#	can't do this.  
		#		alias_method_chain test_name, :verbosity
		#	end up with 2 methods that begin
		#	with 'test_' so they both get run
		#
		alias_method "_#{test_name}_without_verbosity".to_sym,
			test_name
		alias_method test_name,
			"_#{test_name}_with_verbosity".to_sym
		end

	alias_method :test_without_verbosity, :test
	alias_method :test, :test_with_verbosity

end
::Test::Unit::TestCase.send(:extend,Declarative)
