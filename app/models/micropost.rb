# == Schema Information
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Micropost < ActiveRecord::Base
  attr_accessible :content
  belongs_to :user 
  
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  default_scope order: 'microposts.created_at DESC'
  
  # Devuelve microposts de los usuarios que están siendo seguidos por el usuario dado.
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  #def self.from_users_followed_by(user)
  #  followed_user_ids = user.followed_user_ids.join(', ')
  #  where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
  #end
  
  private
  
    # Retorna una condicion SQL para usuarios seguidos por el usuario dado
    # Incluimos el ID del propio usuario tambien
    def self.followed_by(user)
      #followed_user_ids = user.followed_user_ids <== remplazado por 
      followed_user_ids = %(SELECT followed_id FROM relationships
                            WHERE follower_id = :user_id)      
      where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
              { user_id: user })
    end
end