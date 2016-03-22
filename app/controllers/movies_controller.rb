class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def index
    @all_ratings = ['G','PG','PG-13','R']
    
    if !params[:ratings].nil?
      @selected = params[:ratings]
    elsif !session[:ratings].nil?
      @selected = session[:ratings]
      redirect_to action: 'index', :ratings => @selected
    else
      @selected = @all_ratings
      redirect_to action: 'index', :ratings => @all_ratings
    end
    
    if !params[:sort].nil?
      @sort = params[:sort]
    elsif !session[:sort].nil?
      redirect_to action: 'index', :sort => session[:sort]
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
