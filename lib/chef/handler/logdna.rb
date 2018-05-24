require 'rubygems'
require 'chef/handler'
require 'chef/mash'
require 'logdna'
require 'macaddr'
require 'json'

class Chef
	class Handler
		class LogDNA < Chef::Handler

			attr_reader :config

			def initialize(config={})
				@config = Mash.new(config)
				@ldna = prepare_logdna
			end

			def report
				if run_status.success?
					status = "SUCCESS"
				else
					status = "FAILURE"
				end
		                line = run_status
				sendLog status line
			end

			def get_hostname
				node = run_status.node
				use_ec2_instance_id = !config.key?(:use_ec2_instance_id) || (config.key?(:use_ec2_instance_id) && config[:use_ec2_instance_id])
				if config[:hostname]
					config[:hostname]
				elsif use_ec2_instance_id && node.attribute?('ec2') && node.ec2.attribute?('instance_id')
					node.ec2.instance_id
				else
					node.name
				end
			end

			def prepare_logdna
				options = {:hostname => get_hostname, :index_meta => true, :mac => Mac.addr}
				logdna_key = config[:logdna_key]
				if !config.key?(:logdna_key)
					Chef::Log.warn("You need LogDNA Ingestion Key in order to stream logs")
					fail ArgumentError, 'Missing LogDNA Ingestion Key'
					return false
				else
					Logdna::Ruby.new(config[:logdna_key], options)
				end
			end

			def sendLog(status, line)
				unless @ldna.nil?
					@ldna.log(line, {:app => "chef", :level => status})
				else
					Chef::Log.warn("LogDNA Handler has not been set properly")
				end
			rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT => e
				Chef::Log.error("Connection error:\n"+e)
			end
		end
	end
end
