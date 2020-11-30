class ArtistsController < ApplicationController
    get "/artists" do
        @artists = Artist.all.order(:name)
        erb :"artists/index"
    end

    get "/artists/:slug" do
        @artist = Artist.find_by_slug(params[:slug])
        @songs = @artist.songs.order(:name)
        @genres = @artist.genres.order(:name)
        erb :"artists/show"
    end
end
