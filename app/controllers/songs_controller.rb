require 'sinatra/base'
require 'rack-flash'
class SongsController < ApplicationController

  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs=Song.all
    erb :"songs/index"
  end

  get '/songs/new' do
    erb :"/songs/new"
  end

  post '/songs' do
    @song=Song.create(:name=>params["Name"])
    @artist=Artist.find_or_create(params["Artist Name"])
    @artist.songs<<@song
    @song.genre_ids=params["genres"]
    flash[:message] = "Successfully created song."
    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug/edit' do
    @song=Song.find_by_slug(params[:slug])
    erb :"/songs/edit"
  end

  patch '/songs/:slug' do

    @song=Song.find_by_slug(params[:slug])
    @song.name=params["Name"]
    @song.artist=Artist.create(:name=>params["Artist Name"])
    @song.genre_ids=params["genres"] if params["genres"]
    @song.save
    flash[:message] = "Successfully updated song."
    redirect to "/songs/#{@song.slug}"
  end

  get '/songs/:slug' do
    @song= Song.find_by_slug(params[:slug])
    erb :"/songs/show"
  end

end
