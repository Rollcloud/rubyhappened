class Commit
  def initialize(refs, message)
    # Instance variables
    @refs = refs
    @message = message
  end

  # def bark
  #   puts 'Ruff! Ruff!'
  # end

  # def display
  #   puts "I am of #{@breed} breed and my name is #{@name}"
  # end
end

# make an object
# Objects are created on the heap

git_log_command = "git log --pretty='format:%d|%s'"
git_log = `#{git_log_command}`
# puts git_log
# puts ''
commit_log = git_log.split("\n")
# puts commit_log.inspect
# puts ''
commits = []
for each in commit_log
  refs, message = each.split("|", 2)
  commits.append(Commit.new(refs, message))
end

puts commits.inspect
