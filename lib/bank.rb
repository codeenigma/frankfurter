# frozen_string_literal: true

require 'currency'
require 'bank/feed'

module Bank
  def self.fetch_all!
    Currency.dataset.insert_conflict.multi_insert(Feed.historical.to_a)
  end

  def self.fetch_ninety_days!
    Currency.dataset.insert_conflict.multi_insert(Feed.ninety_days.to_a)
  end

  def self.fetch_current!
    Currency.db.transaction do
      Feed.current.each do |hsh|
        Currency.find_or_create(hsh)
      end
    end
  end

  def self.replace_all!
    Currency.dataset.delete
    Currency.multi_insert(Feed.historical.to_a)
  end
end
