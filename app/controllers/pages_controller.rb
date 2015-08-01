class PagesController < ApplicationController
  def about
    @current_page_title = 'About'
  end

  def home
    @current_page_title = 'Home'
  end
end
