class ProfilersController < ApplicationController
  def rmp
    if params[:enabled] == "true"
      session[:rmp] = true
      message = "RMP enabled"
    elsif params[:enabled] == "false"
      session[:rmp] = false
      message = "RMP disabled"
    else
      not_found
    end

    redirect_back fallback_location: root_path, notice: message
  end
end
