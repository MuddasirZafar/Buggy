class PagesController < ApplicationController
  def home
    if !user_signed_in?
      render :template => "layouts/homepage"
    end
  end
end
