class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def index
    @movies = Movie.all

    if params[:ratings].nil? && !session[:ratings].nil?
      @selected = session[:ratings]
    elsif params[:ratings].nil? && session[:ratings].nil?
      @selected = ['G','PG','PG-13','R']
    elsif !params[:ratings].nil?
      @selected = params[:ratings].keys
    end
    
    @all_ratings = ['G','PG','PG-13','R']
    
    if params[:sort].nil? && !session[:sort].nil?
      @sort = session[:sort]
    elsif !params[:sort].nil?
      @sort = params[:sort]
    end
    
    if @selected.respond_to? 'keys'
      @movies = Movie.where(rating: @selected.keys)
    else
      @movies = Movie.where(rating: @selected)
    end
    
    if !@selected.nil? && !@selected.empty?
      @movies.each{|m|
        if !@selected.include?(m.rating)
          @movies -= [m]
        end
      }
      session[:ratings] = params[:ratings]
    end
    
    if @sort == "title"
      @movies = @movies.sort_by{|m| m[:title]}
      session[:sort] = @sort
    elsif @sort == "release_date"
      @movies = @movies.sort_by{|m| m[:release_date]}
      session[:sort] = @sort
    end
  end
  
  
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
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
