require 'singleton'

class JournalCenter
  include Singleton

  def initialize
    @config = {
      :add_journal_on_issue_creation => true
    }
  end
  attr_reader :config

  def add_journal_on_issue_creation?
    config[:add_journal_on_issue_creation]
  end
end

=begin in an initializers:
JournalCenter.instance.config.merge!(
  :add_journal_on_issue_creation => false
)
=end
