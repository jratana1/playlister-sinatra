require 'sinatra/base'
require 'rack-flash'
class SongsController < ApplicationController
  enable :sessions
  use Rack::Flash
    get "/songs" do
        @songs = Song.all.order(:name)
        erb :"songs/index"
      end

    get "/songs/new" do
      @artists = Artist.all
      @genres = Genre.all
      erb :"songs/new"
    end

    post "/songs" do 
    @song = Song.create(params[:song])
  
    # if !params["artist"]["name"].empty?
    #   @song.artist = Artist.create(params[:artist])
    #   @song.save
    # end
    
    # if !params[:song_genres][:genre_ids].empty?
    #   params[:song_genres][:genre_ids].each do |id|
    #     @song.genres << Genre.find(id)
    #   end
    # end

    # if !params["genre"]["name"].empty?
    #   @song.genres << Genre.create(params[:genre])
    # end
    
    artist_entry = params[:artist][:name]
    if Artist.find_by(:name => artist_entry)
      artist = Artist.find_by(:name => artist_entry)
    else
      artist = Artist.create(:name => artist_entry)
    end
    @song.artist = artist

    genre_selections = params[:song_genre][:genre_ids]
    genre_selections.each do |genre|
      @song.genres << Genre.find(genre)
    end

    @song.save
    
    flash[:notice] = "Successfully created song."
    redirect "songs/#{@song.slug}"
    
    end

    get "/songs/:slug" do
      @song = Song.find_by_slug(params[:slug])
      @artist = @song.artist
      @genres = @song.genres.order(:name)
      erb :"songs/show"
    end 

    get "/songs/:slug/edit" do
      @song = Song.find_by_slug(params[:slug])
      @genres= Genre.all.order(:name)
      erb :"songs/edit"
    end

    patch '/songs/:slug' do 

      if !params[:genre].keys.include?("genre_ids")
        params[:genre]["genre_ids"] = []
      end
  
      @song = Song.find_by_slug(params[:slug])
      @song.update(params[:song])
      
      artist_entry = params[:artist][:name]
        if Artist.find_by(:name => artist_entry)
          artist = Artist.find_by(:name => artist_entry)
        else
          artist = Artist.create(:name => artist_entry)
        end
      @song.artist = artist

      @song.genres.clear
      genre_selections = params[:genre][:genre_ids]
        genre_selections.each do |genre|
          @song.genres << Genre.find(genre)
        end

        @song.save
       
      flash[:notice] = "Successfully updated song."
      redirect "songs/#{@song.slug}"
    end
    
end