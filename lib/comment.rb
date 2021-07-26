# frozen_string_literal: true

require 'csv'

# Handles comments bound to a gossip
class Comment
  attr_accessor :id, :author, :content

  def initialize(id, author, content)
    @id = id
    @author = author
    @content = content
  end

  def save
    CSV.open('./db/comment.csv', 'ab', liberal_parsing: true) do |csv|
      csv << [@id, @author, @content]
    end
  end

  def self.all
    all_comment = []
    CSV.read('./db/comment.csv').each do |comment_entry|
      all_comment << Comment.new(comment_entry[0], comment_entry[1], comment_entry[2])
    end
    all_comment
  end

  def self.create_db
    return if File.exist?('./db/comment.csv')

    FileUtils.mkdir_p './db'
    FileUtils.touch './db/comment.csv'
  end

  def self.find(id)
    all.select { |s| s.id == id }
  end
end
