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
    req = false
    if(params[:order])
      @order = params[:order]
    elsif(session[:order])
      @order = session[:order]
      req = true
    end
    
    if(params[:ratings])
      @checked_ratings = params[:ratings]
    elsif(session[:ratings])
      @checked_ratings = session[:ratings]
      req = true
    else
      @all_ratings.each do |rating|
        (@checked_ratings ||= {}) [rating]=1
      end
    end
    
    session[:order] = @order
    session[:ratings] = @checked_ratings
    
    if req
      redirect_to movies_path(:order => @order, :ratings => @checked_ratings)
    end
    
    #Filter ratings
    if (session[:ratings] != nil)
      @movies = Movie.where(rating: @checked_ratings.keys) #Filter based on ratings stored in session
    else
      @movies = Movie.all
    end
    
    #Sort the results based on sort parameters
    if(@order == :title.to_s)
      @movies = @movies.order(:title).all
    elsif (@order == :release_date.to_s)
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
