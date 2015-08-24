require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		(message.length <= 140)? @client.update(message) : (puts "Message exceeds 140 characters. Did not post.")
	end


	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		screen_names = followers_list
		screen_names.include?(target) ? tweet("d @#{target} #{message}") : (puts "Error: you can only DM people who follow you.")
	end

	def followers_list
		@client.followers.collect { |follower| @client.user(follower).screen_name }
	end

	def spam_my_followers(message)
		followers_list.each { |follower| dm(follower, message) }
	end

	def everyones_last_tweet
		friends = @client.friends.to_a.sort_by {|friend| @client.user(friend).name.to_s.downcase}
		friends.each do |friend|
			last_tweet = @client.user(friend).status
			timestamp = last_tweet.created_at.strftime("%A, %b %d")
			puts "#{@client.user(friend).name.to_s} tweeted:"
			puts last_tweet.text.to_s
			puts "Tweeted on: #{timestamp}"
			puts
		end
	end



	def run 
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command: "
			input = gets.chomp
			parts = input.split(' ')
			command = parts[0]
			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(parts[1..-1].join(' '))
			when 'dm' then dm(parts[1], parts[2..-1].join(' '))
			when 'spam' then spam_my_followers(parts[1..-1].join(' '))
			when 'elt' then everyones_last_tweet
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end


end

blogger = MicroBlogger.new
blogger.run
