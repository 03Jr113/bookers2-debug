class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :favorites
  has_many :post_comments
  
  has_many :follower, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followed, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower
  
  has_one_attached :profile_image

  validates :name, presence: true, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }
  
  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end
  
  def follow(user_id)
    follower.create(followed_id: user_id)
  end
  
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end
  
  def following?(user)
    following_user.include?(user)
  end
  
  def self.looks(method, content)
    if method == "perfect_match"
      @user = User.where("name LIKE?", "#{content}")
    elsif method == "forward_match"
      @user = User.where("name LIKE?","#{content}%")
    elsif method == "backward_match"
      @user = User.where("name LIKE?","%#{content}")
    else
      @user = User.where("name LIKE?","%#{content}%")
    end
  end
  
end
