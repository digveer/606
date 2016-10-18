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
    redirect=false
    @i_ratings=params[:ratings] ? params[:ratings]:session[:rating]
    @i_sort=params[:sort_by] ? params[:sort_by]:session[:sort_by]
   
    @all_ratings=Movie.all_ratings
    if(params[:sort_by]!=@i_sort) || (params[:ratings]!=@i_ratings)
      redirect=true
    end 
    
    if @i_ratings.nil?
      @i_ratings={}
      @all_ratings.each{|i| @i_ratings[i]=1}
    end
    
    if(redirect==true)
      flash.keep
      redirect_to movies_path(sort_by:@i_sort,ratings:@i_ratings)
    end
    
    if @i_ratings
      @movies=Movie.where(:rating => @i_ratings.keys).order(@i_sort)
    end  
    
    session[:rating]  =@i_ratings
    session[:sort_by] =@i_sort
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
