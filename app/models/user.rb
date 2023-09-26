class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  has_many :active_r, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_r, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  has_many :followings, through: :active_r, source: :followed
  has_many :followers, through: :passive_r, source: :follower


  has_one_attached :profile_image
  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def follow(user)
    active_r.create(followed_id: user.id)
  end

  def unfollow(user)
    active_r.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    followings.include?(user)
  end
end
