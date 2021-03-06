class ReviewsController < ApplicationController
  before_action :authenticate_user!
  # this is added afer the method was created in application controller
  before_action :find_product
  before_action :find_review, :authorize_user!, only: [:destroy, :update]


  def create
    # 1 - get new inputs (rating, body) from the new form
    # 2 - pass & store the parameters to the new review
    # 3 - associate the new review with the parent
    # 4 - try to save it

    @review = Review.new(review_params)
    @review.product = @product # associate review to the parent product
    @review.user = current_user
     # in order to add username next to the review, order matters!!!!!!!

    if @review.save
      # ReviewMailer.notify_product_owner(@review).deliver_now
      #--[JOB]----------------------------------------------------------
      ReviewCreateReminderJob.set(wait:10.seconds).perform_later
      # ReviewCreateReminderJob.perform_now
      #-----------------------------------------------------------------
      redirect_to product_path(@product)
    else
      @reviews = @product.reviews.order(created_at: :desc)
      render 'products/show'
    end

  end

  def destroy

    @review.destroy
    redirect_to product_path(@product)
  end
  #
  # def hide
  #   # then to the show page
  #  if @review.is_hidden?
  #    @review.is_hidden = false
  #    @review.save
  #    redirect_to product_path(@product)
  #  else
  #    @review.is_hidden = true
  #    @review.save
  #    redirect_to product_path(@product)
  #  end
  #
  # end

  def update # for hidden function
      # @review = Review.find params[:id]
      if @review.update(review_params)
        redirect_to product_path(@product)
      else
        render :edit
      end
  end

private

  def review_params # add is_hidden for hidden function
    params.require(:review).permit(:rating, :body, :is_hidden)
  end

  def find_product
    @product = Product.find params[:product_id]
  end


  def find_review # add this (from destroy)
    @review = Review.find params[:id]
  end

  def authorize_user! # add find_answer, then add before_action on top
    unless can?(:crud, @review) || can?(:crud, @product)
      flash[:alert] = "Access Denied!"
      redirect_to home_path
    end
  end


end
