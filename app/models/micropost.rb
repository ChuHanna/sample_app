class Micropost < ApplicationRecord
  belongs_to :user
  scope :newest, ->{order created_at: :desc}
  scope :recent_posts, ->{order created_at: :desc}
  has_one_attached :image
  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.maclencontent}
  validates :image, content_type: {in: Settings.image_type,
                                   message: :invalid_mess},
             size: {less_than: Settings.max_image_size.megabytes,
                    message: :large_size_}

  def display_image
    image.variant resize_to_limit: Settings.image_limit
  end
end
