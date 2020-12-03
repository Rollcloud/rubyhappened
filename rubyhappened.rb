# frozen_string_literal: true

require './lib/commit'
require './lib/version'

# === start here ===
# load git log
git_log_command = "git log --pretty='format:%d|%s'"
git_log = `#{git_log_command}`
# puts git_log
# puts ''

# parse log into Commits
commit_log = git_log.split("\n")
# puts commit_log.inspect
# puts ''
commits = []
commit_log.each do |each|
  refs, subject = each.split('|', 2)
  commits.append(Commit.new(refs, subject))
end

# puts commits.inspect

# get last version
last_version_index = commits.find_index(&:semver)
version = Version.new(commits[last_version_index].semver)
# puts commits[last_version_index].subject
# puts commits[last_version_index].message.inspect
# puts commits.map(&:message)

# for Commit in commits between last_version_index and 0
commits_new = commits[0..last_version_index - 1]
# check breaking not nil
any_breaking = commits_new.any? { |c| c.message.respond_to?(:breaking) }
# check groups like feat*
any_features = commits_new.any? { |c| c.message.fetch('type') =~ /feat/ }
# check groups like fix*
any_fixes = commits_new.any? { |c| c.message.fetch('type') =~ /fix/ }

# output new version
if any_breaking
  version.major += 1
  version.minor = 0
  version.patch = 0

elsif any_features
  version.minor += 1
  version.patch = 0

elsif any_fixes
  version.patch += 1

end

version_new = '%<major>s.%<minor>s.%<patch>s'
puts format(version_new,
            major: version.major,
            minor: version.minor,
            patch: version.patch)
