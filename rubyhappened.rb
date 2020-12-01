class Commit
  def initialize(refs, message)
    # Instance variables
    @refs = refs
    @message = message
  end

  def refs
    @refs
  end

  def message
    @message
  end

  def semver
    @refs.match(/(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?/)
  end
end

# make an object
# Objects are created on the heap

git_log_command = "git log --pretty='format:%d|%s' --reverse"
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

# puts commits.inspect

first_tagged_commit = commits.first{|x| x.refs.include?("tag")}
puts first_tagged_commit.semver.named_captures
