class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    sort = params[:sort] || session[:sort]
    if(params[:sort] == "title")
      @title = "hilite"
    elsif(params[:sort] == "release_date")
      @release_date = "hilite"
    end
    #if(params[:ratings] != nil)
     # @movies = Movie.where("Rating IN (?)", params[:ratings].keys).order(params[:sort])
    #else
     # @movies = Movie.order(params[:sort])
    #end
    @current_ratings = params[:ratings] || session[:ratings] || {}
    if @current_ratings == {}
      @current_ratings = Hash[@all_ratings.map{|rating| [rating,rating]}]
    end
    if session[:ratings] != params[:ratings] && @current_ratings != {}
      session[:sort] = sort
      session[:ratings] = @current_ratings
      flash.keep
      redirect_to :sort => sort, :ratings => @current_ratings and return
    end
    if session[:sort] != params[:sort]
      session[:sort] = params[:sort]
      flash.keep
      redirect_to :sort => sort, :ratings => @current_ratings and return
    end
    @movies = Movie.where(rating: @current_ratings.keys).order(sort)
  end
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
