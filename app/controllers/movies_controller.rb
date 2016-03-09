class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def index
    @sort = params[:sort]
    @movies = Movie.all
    @all_ratings = Array.new
    
    @movies.each{|m|
      if !@all_ratings.include?(m.rating.to_s)
        @all_ratings.insert(@all_ratings.length,m.rating.to_s)
      end
    }
    
    if !params[:ratings].nil?
      @movies.each{|m|
        if !params[:ratings].has_key?(m.rating)
          @movies -= [m]
        end
      }
    end
    
    if @sort == "title"
      @movies = @movies.sort_by{|m| m[:title]}
    elsif @sort == "release_date"
      @movies = @movies.sort_by{|m| m[:release_date]}
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
