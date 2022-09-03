class SearchesController < ApplicationController
  
  def search
    @range = params[:range]
    @content = params[:content]
    
    if @range == "User"
      @users = User.looks(params[:method], params[:content])
    else
      @books = Book.looks(params[:method], params[:content])
    end
    
  end
  
end
