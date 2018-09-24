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
    @all_ratings = Movie.ratings #Get all ratings
    if(params[:ratings] == nil) 
      @checked_ratings = @all_ratings
    else
      @checked_ratings = params[:ratings].keys
    end
    if(session[:ratings] != params[:ratings] && params[:ratings]!=nil) #Store ratings in session
      session[:ratings] = params[:ratings]
    else
      @checked_ratings = session[:ratings].keys
    end
    if (session[:ratings] != nil)
      @movies = Movie.where(rating: session[:ratings].keys) #Filter based on ratings stored in session
    else
      @movies = Movie.all
    end
    if(params[:order] == :title.to_s)
      @movies = @movies.order(:title).all
    elsif (params[:order] == :release_date.to_s)
      @movies = @movies.order(:release_date).all
    end
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
