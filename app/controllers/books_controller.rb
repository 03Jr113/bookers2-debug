class BooksController < ApplicationController
  
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
    @post_comment = PostComment.new
  end

  def index
    @books = Book.all
    #ずべての投稿を呼び出すときに使用する
    @book = Book.new
    #新規投稿フォームで使用する
  end

  def create
    @book = Book.new(book_params)
    #book_paramsで許可したカラムのみを受け取って新しいレコードを作成する
    @book.user_id = current_user.id
    #投稿者を特定できるように新しいレコードを作る際に現在のユーザのIDを付与する
    if @book.save #バリデーションを通過できていたら
      redirect_to book_path(@book), notice: "You have created book successfully."
    else #バリデーションエラーがあったら
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @new_book = Book.new
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
  
  def ensure_correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to books_path unless @user == current_user
  end
  
end
