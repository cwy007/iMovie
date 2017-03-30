class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    @movie = Movie.find(params[:movie_id])
    if !current_user.has_collected?(@movie)
      redirect_to movie_path(@movie)
      flash[:warning] = "You need to favorite this movie before writing a review."
    end
    @review = Review.new
  end

  def edit
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
  end

  def create
    @movie = Movie.find(params[:movie_id])
    @review = Review.new(review_params)
    @review.movie = @movie
    @review.user = current_user

    if @review.save
      redirect_to movie_path(@movie)
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to account_reviews_path, notice: "Update successfully"
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to account_reviews_path, alert: "Review deleted"
  end

  private

  def review_params
    params.require(:review).permit(:content)
  end

end
