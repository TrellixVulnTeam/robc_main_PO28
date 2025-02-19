#!/usr/bin/env ruby
 
# Script to clean up stored configs for (a) given host(s)
#
# Credits:
# Script was taken from http://reductivelabs.com/trac/puppet/attachment/wiki/UsingStoredConfiguration/kill_node_in_storedconfigs_db.rb
# which haven been initially posted by James Turnbull
# duritong adapted and improved the script a bit.
 
require 'getoptlong'
config = '/etc/puppet/puppet.conf'
kill_all = false
 
def printusage(error_code)
    puts "Usage: #{$0} [ list of hostnames as stored in hosts table ]"
    puts "\n Options:"
    puts "--config <puppet config file>"
    exit(error_code)
end
 
opts = GetoptLong.new(
        [ "--config", "-c", GetoptLong::REQUIRED_ARGUMENT ],
        [ "--help", "-h", GetoptLong::NO_ARGUMENT ],
        [ "--usage", "-u", GetoptLong::NO_ARGUMENT ],
        [ "--version", "-v", GetoptLong::NO_ARGUMENT ],
        [ "--all", "-a", GetoptLong::NO_ARGUMENT]
)
 
begin
opts.each do |opt, arg|
     case opt
           when "--all"
             kill_all = true

           when "--config"
             config = arg
 
           when "--help"
             printusage(0)
 
           when "--usage"
             printusage(0)
 
           when "--version"
              puts "%s" % Puppet.version
              exit
    end
end
rescue GetoptLong::InvalidOption => detail
    $stderr.puts "Try '#{$0} --help'"
    exit(1)
end
 
printusage(1) unless (ARGV.size > 0) or kill_all 
 
require 'puppet/rails'
Puppet[:config] = config
Puppet.parse_config
pm_conf = Puppet.settings.instance_variable_get(:@values)[:puppetmasterd]
pm_conf = Puppet.settings.instance_variable_get(:@values)[:master] if pm_conf.nil? or pm_conf.empty?
 
adapter = pm_conf[:dbadapter]
args = {:adapter => adapter, :log_level => pm_conf[:rails_loglevel]}
 
case adapter
  when "sqlite3":
    args[:dbfile] = pm_conf[:dblocation]
  when "mysql", "postgresql":
    args[:host] = pm_conf[:dbserver] unless pm_conf[:dbserver].to_s.empty?
    args[:username] = pm_conf[:dbuser] unless pm_conf[:dbuser].to_s.empty?
    args[:password] = pm_conf[:dbpassword] unless pm_conf[:dbpassword].to_s.empty?
    args[:database] = pm_conf[:dbname] unless pm_conf[:dbname].to_s.empty?
    socket = pm_conf[:dbsocket]
    args[:socket] = socket unless socket.to_s.empty?
  else
    raise ArgumentError, "Invalid db adapter %s" % adapter
end
 
args[:database] = "puppet" unless not args[:database].to_s.empty?
 
ActiveRecord::Base.establish_connection(args)

if kill_all
  # truncates puppet's store config tables
  puppet_tables = ["resources", "source_files", "resource_tags", "puppet_tags", "hosts", "fact_names", "fact_values", "param_values", "param_names"]
  puppet_tables.each do |table|
    print "Deleting #{table}..."
    ActiveRecord::Base.connection.execute("DELETE FROM #{table};")
    puts "done"
  end
else
	ARGV.each { |hostname|
		if @host = Puppet::Rails::Host.find_by_name(hostname.strip)
			print "Killing #{hostname}..."
			$stdout.flush
			@host.destroy
			puts "done."
		else
			puts "Can't find host #{hostname}."
		end
	}
end
exit 0
