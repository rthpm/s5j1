# frozen_string_literal: true

require 'csv'

# Handles gossips creation, edits and whatnot
class Gossip
  attr_accessor :author, :content

  def initialize(author, content)
    @author = author
    @content = content
  end

  def save
    CSV.open('./db/gossip.csv', 'ab') do |csv|
      csv << [@author, @content]
    end
  end

  def self.all
    all_gossips = []
    CSV.read('./db/gossip.csv').each do |gossip_entry|
      all_gossips << Gossip.new(gossip_entry[0], gossip_entry[1])
    end
    all_gossips
  end

  def self.find(id)
    all[id.to_i]
  end

  def self.update(id, author, content)
    new_gossip = CSV.read('./db/gossip.csv')
    new_gossip[id.to_i][0] = author
    new_gossip[id.to_i][1] = content
    CSV.open('./db/gossip.csv', 'w') do |csv|
      new_gossip.each do |edits|
        csv << edits
      end
    end
  end

  def self.create_db
    return if File.exist?('.db/gossip.csv')

    FileUtils.mkdir_p './db'
    FileUtils.touch './db/gossip.csv'
  end
end
