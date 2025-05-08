class TeasController < ApplicationController
    before_action :require_login
    before_action :set_tea, only: [ :show, :edit, :update, :destroy ]

    def index
      @teas = current_user.teas.includes(:entries)
      @entries = current_user.entries.index_by(&:tea_id)
    end

    def show
      @entry = current_user.entries.find_by(tea: @tea)
      unless @entry
        redirect_to teas_path, alert: "You don't have access to this tea."
      end
    end

    def new
      @tea = Tea.new
    end

    def create
      @tea = Tea.new(tea_params)
      
      ActiveRecord::Base.transaction do
        if @tea.save
          @entry = Entry.create!(tea: @tea, user: current_user, rank: params[:tea][:rank])
          redirect_to tea_path(@tea), notice: "Tea was successfully created."
        else
          flash.now[:alert] = "There was an error creating the tea."
          render :new, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "There was an error creating the tea."
      render :new, status: :unprocessable_entity
    end

    def edit
      @entry = current_user.entries.find_by(tea: @tea)
      unless @entry
        redirect_to teas_path, alert: "You don't have access to this tea."
      end
    end

    def update
      @entry = current_user.entries.find_by(tea: @tea)
      unless @entry
        redirect_to teas_path, alert: "You don't have access to this tea."
        return
      end

      if @tea.update(tea_params)
        redirect_to tea_path(@tea), notice: "Tea updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @entry = current_user.entries.find_by(tea: @tea)
      if @entry
        @entry.destroy
        if @tea.entries.empty?
          @tea.destroy
        end
        redirect_to teas_path, notice: "Tea was successfully removed from your collection."
      else
        redirect_to teas_path, alert: "You don't have access to this tea."
      end
    end

    private

    def set_tea
      @tea = Tea.find(params[:id])
    end

    def tea_params
      params.require(:tea).permit(:name, :price, :category, :vendor, :known_for, :ship_from, :popularity, :shopping_platform, :product_url)
    end

    def require_login
      redirect_to new_session_path unless current_user
    end
end
