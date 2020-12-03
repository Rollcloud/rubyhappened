# frozen_string_literal: true

# A class for each Git commit
class Commit
  def initialize(refs, subject)
    # Instance variables
    @refs = refs
    @subject = subject
  end

  attr_reader :refs, :subject

  # return a semver object containing major, minor, patch, prerelease, buildmetadata
  def semver
    regex_semver = /
      (?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)
      (?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)
      (?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+
      (?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?
      /x
    regex_match = @refs.match(regex_semver)
    regex_match&.named_captures
  end

  # return Git-By-Numbers object containing breaking, type, scope, description, body
  def message
    regex_gnb = /
      (?<breaking>breaking )?
      (?<type>[0-9a-zA-Z]+) ?
      (?:\((?<scope>[0-9a-zA-Z.-]+)\))?
      :[ ]?
      (?<description>.*)
      # \\n?(?<body>.+)?
    /x
    regex_match = @subject.match(regex_gnb)
    regex_match&.named_captures
  end
end
