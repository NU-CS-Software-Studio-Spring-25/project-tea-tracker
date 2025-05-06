class HomeController < ApplicationController
  before_action :require_login

  def index
    if current_user
     
      @categories = current_user.teas.select(:category).distinct.pluck(:category)
      @sort = params[:sort]
      @filter = params[:filter]
      @teas = Tea.where(user_id: current_user.id)
      @teas = @teas.where(category: @filter) if @filter.present?
      @teas = @teas.order(price: :asc) if @sort == "price_asc"
      @teas = @teas.order(price: :desc) if @sort == "price_desc"

      @most_common_category = Tea.where(user_id: current_user.id)
                              .group(:category)
                              .order('count_id DESC')
                              .count(:id)
                              .first&.first

      @average_price = @teas.average(:price)
      render :dashboard
    else
      render :landing
    end
  end

  private

  def require_login
    unless current_user
      redirect_to new_session_path, alert: "You must log in first."
    end
  end
  
end
