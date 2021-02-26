class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if !params[:sort].nil?
      @sort = params[:sort]
      session[:sort] = @sort
    else
      @sort = nil
    end
    
    @ratings = params[:ratings] 
    session[:ratings] = @ratings
    
    @all_ratings = Movie.ratings.inject(Hash.new) do |all_ratings, rating|
      all_ratings[rating] = @ratings.nil? ? false : @ratings.has_key?(rating) 
      all_ratings
    end
    
    #@movies = Movie.all
    if @sort.nil? && @ratings.nil?
      @movies = Movie.all
    elsif !@sort.nil? && !@ratings.nil?
      @movies = Movie.where(:rating => @ratings.keys).order(@sort)
      
    elsif @ratings.nil?
      @movies = Movie.order(@sort)
    else
      @movies = Movie.where(:rating => @ratings.keys)
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
