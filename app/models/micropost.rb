class Micropost < ActiveRecord::Base
  attr_accessible :content, :photo
  belongs_to :user

  has_attached_file :photo, :styles => { :small => "150x150>" },
                  :url  => "/assets/microposts/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/assets/microposts/:id/:style/:basename.:extension"

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end
end