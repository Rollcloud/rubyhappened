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

  # return a semver object containing major, minor, patch, prerelease, buildmetadata
  def semver
    @refs.match(/(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?/).named_captures
  end

  # return Git-By-Numbers object containing breaking, type, scope, description, body
  def parameters
    parameters_match = @message.match(/(?<breaking>breaking )?(?<type>[0-9a-zA-Z]+): ?(?<description>.*)(\n?)(?<body>.+)?/)
    if parameters_match != nil
      parameters_match.named_captures
    end
  end
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

# puts commits.inspect

last_version_index = commits.find_index{ | each | each.semver }
puts commits[last_version_index].semver
puts commits.map{ | each | each.type }
