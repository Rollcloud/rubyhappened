# frozen_string_literal: true

# A class for an application version, consisting of many sequential commits
class Version
  def initialize(semver_prev)
    @semver_prev = semver_prev

    @major = semver_prev.fetch('major').to_i
    @minor = semver_prev.fetch('minor').to_i
    @patch = semver_prev.fetch('patch').to_i
  end

  attr_accessor :major, :minor, :patch
end
