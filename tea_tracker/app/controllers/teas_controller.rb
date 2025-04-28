class TeasController < ApplicationController
    def show
        @tea = Tea.find(params[:id])
    end
end
    
