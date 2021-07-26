# frozen_string_literal: true

require 'gossip'
require 'comment'

# Glue between views and gossips/comments
class ApplicationController < Sinatra::Base
  get '/' do
    Gossip.create_db
    Comment.create_db
    erb :index, locals: { gossips: Gossip.all }
  end

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    Gossip.new(params['gossip_author'], params['gossip_content']).save
    redirect '/'
  end

  get '/gossips/:id' do
    erb :show, locals: {
      gossip: Gossip.find(params['id']),
      id: params['id'],
      comment: Comment.find(params['id'])
    }
  end

  post '/gossips/:id' do
    Comment.new(params['id'], params['comment_author'], params['comment_content']).save
    redirect '/'
  end

  get '/gossips/:id/edit' do
    erb :edit, locals: {
      gossip: Gossip.all[params[:id].to_i],
      id: params[:id]
    }
  end

  post '/gossips/:id/edit' do
    Gossip.update(params['id'], params['gossip_author'], params['gossip_content'])
    redirect '/'
  end
end
