# frozen_string_literal: true

class Rule
  attr_reader :regex

  def initialize(regex:, tokenize_rule:)
    @regex = regex
    @tokenize_rule = tokenize_rule
  end

  def applies_to?(markdown)
    regex.match?(markdown)
  end

  def tokenize(markdown)
    tokenize_rule.call(markdown, regex)
  end

  private

  attr_reader :tokenize_rule
end
