class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  
  validates :title, presence:true
  validates :body, presence:true, length: { maximum:200 }
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.looks(method, content)
    if method == "perfect_match"
      @book = Book.where("title LIKE?","#{content}")
    elsif method == "forward_match"
      @book = Book.where("title LIKE?","#{content}%")
    elsif method == "backward_match"
      @book = Book.where("title LIKE?","%#{content}")
    else
      @book = Book.where("title LIKE?","%#{content}%")
    end
  end
  
end
